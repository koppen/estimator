require "colorize"

class Renderer
  attr_reader :estimate

  def initialize(estimate)
    @estimate = estimate
  end

  def output
    puts format("%-40s %13s  %13s  %13s", "Estimate", "Hours", "Days", "Iterations")
    puts

    estimate.tasks.each do |task|
      output_task(task)
    end

    puts format("%-40s %13s  %13s  %13s", "", "Hours", "Days", "Iterations")
    puts format_aggregate_row(
      "Total",
      estimate.hours.first,
      estimate.hours.last,
      estimate.days.first,
      estimate.days.last,
      estimate.iterations.first,
      estimate.iterations.last
      )
    puts

    puts format("%-70s %6i %6i", "Total price", estimate.price.first, estimate.price.last)
  end

  private

  def format_row(*args)
    format(
      "%-40s %6.0f %6.0f",
      *args
    )
  end

  def format_aggregate_row(*args)
    format(
      "%-40s %6.0f %6.0f  %6.0f %6.0f  %6.0f %6.0f",
      *args
    )
  end

  def indent(name, level)
    return name if root?(level)
    indent = "  " * (level - 1) + "* "
    indent + name
  end

  def output_task(task, level = 0)
    indented_name = indent(task.name, level)

    row = if root?(level)
      min_hours = task.min_hours
      max_hours = task.max_hours

      format_aggregate_row(
        indented_name,
        min_hours.round(1),
        max_hours.round(1),
        estimate.hours_to_days(min_hours),
        estimate.hours_to_days(max_hours),
        estimate.hours_to_iterations(min_hours),
        estimate.hours_to_iterations(max_hours)
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

  def root?(level)
    level.zero?
  end
end
