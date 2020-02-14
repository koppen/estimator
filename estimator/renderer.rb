# frozen_string_literal: true

require "colorize"

class Renderer
  attr_reader :estimate

  def initialize(estimate)
    @estimate = estimate
  end

  def output
    puts format(
      "%-50s %13s  %13s  %13s", "Estimate", "Hours", "Days", "Iterations"
    )
    puts

    output_tasks
    output_totals

    if estimate.derived_values.any?
      output_derived_values
      output_totals(:with_derived => true)
    end

    output_price(:with_derived => true)
  end

  private

  def format_row(*args)
    format(
      "%-50s %6.0f %6.0f",
      *args
    )
  end

  def format_aggregate_row(values)
    format(
      "%<name>-50s "\
      "%<hours_low>6.0f %<hours_high>6.0f  "\
      "%<days_low>6.0f %<days_high>6.0f  "\
      "%<iterations_low>6.0f %<iterations_high>6.0f",
      values
    )
  end

  def indent(name, level)
    return name if root?(level)

    indent = "  " * (level - 1) + "* "
    indent + name
  end

  def output_derived_values
    # Build a grouped task with all the derived values
    group = Task.new("Management")
    estimate.derived_values.each do |derived_value|
      group.add_task(derived_value)
    end

    output_task(group)
  end

  def output_price(with_derived: false)
    if estimate.price_per_iteration
      puts format(
        "%-65s %6.0f %6.0f  %6.0f %6.0f",
        "Total price",
        estimate.price_based_on_days(:with_derived => with_derived).first,
        estimate.price_based_on_days(:with_derived => with_derived).last,
        estimate.price_based_on_iterations(:with_derived => with_derived).first,
        estimate.price_based_on_iterations(:with_derived => with_derived).last
      )
    else
      puts format(
        "%-65s %6.0f %6.0f",
        "Total price",
        estimate.price_based_on_days(:with_derived => with_derived).first,
        estimate.price_based_on_days(:with_derived => with_derived).last
      )
    end

    puts
  end

  def output_task(task, level = 0)
    indented_name = indent(task.name, level)

    row = if root?(level)
      min_hours = task.min_hours
      max_hours = task.max_hours

      format_aggregate_row(
        :name => indented_name,
        :hours_low => min_hours.round(1),
        :hours_high => max_hours.round(1),
        :days_low => estimate.hours_to_days(min_hours),
        :days_high => estimate.hours_to_days(max_hours),
        :iterations_low => estimate.hours_to_iterations(min_hours),
        :iterations_high => estimate.hours_to_iterations(max_hours)
      ).white + "\n"
    else
      format_row(
        indented_name,
        task.min_hours.round(1),
        task.max_hours.round(1)
      )
    end
    puts row

    task.tasks.each do |sub_task|
      output_task(sub_task, level + 1)
    end

    puts if root?(level)
  end

  def output_tasks
    estimate.tasks.each do |task|
      output_task(task)
    end
  end

  def output_totals(with_derived: false)
    puts format("%-50s %13s  %13s  %13s", "", "Hours", "Days", "Iterations")
    puts format_aggregate_row(
      :name => "Total",
      :hours_low => estimate.hours(:with_derived => with_derived).first,
      :hours_high => estimate.hours(:with_derived => with_derived).last,
      :days_low => estimate.days(:with_derived => with_derived).first,
      :days_high => estimate.days(:with_derived => with_derived).last,
      :iterations_low =>
        estimate.iterations(:with_derived => with_derived).first,
      :iterations_high =>
        estimate.iterations(:with_derived => with_derived).last
    )
    puts
  end

  def root?(level)
    level.zero?
  end
end
