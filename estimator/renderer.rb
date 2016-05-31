require "colorize"

class Renderer
  attr_reader :estimate

  def initialize(estimate)
    @estimate = estimate
  end

  def output
    estimate.tasks.each do |task|
      output_task(task)
    end

    puts format_row("Total hours", estimate.hours.first, estimate.hours.last)
    puts format_row("Total days", estimate.days.first, estimate.days.last)
    puts format("%-40s %6i %6i", "Total price", estimate.price.first, estimate.price.last)
  end

  private

  def format_row(*args)
    format(
      "%-40s %6.0f %6.0f",
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

    row = format_row(
      indented_name,
      task.min_hours.round(1),
      task.max_hours.round(1)
    )
    row = row.white if root?(level)
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
