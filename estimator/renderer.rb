class Renderer
  attr_reader :estimate

  def initialize(estimate)
    @estimate = estimate
  end

  def output
    estimate.tasks.each do |task|
      output_task(task)
    end

    puts "Total hours: #{estimate.hours.inspect}"
    puts "Total days: #{estimate.days.inspect}"
    puts "Total price: #{estimate.price.inspect}"
  end

  private

  def indent(name, level)
    return name if root?(level)
    indent = "  " * (level - 1) + "* "
    indent + name
  end

  def output_task(task, level = 0)
    indented_name = indent(task.name, level)

    puts format(
      "%-40s %3i %3i",
      indented_name,
      task.min_hours.round,
      task.max_hours.round
    )

    if root?(level)
      puts [
        "-" * 40,
        "-" * 3,
        "-" * 3
      ].join("-")
    end
    task.tasks.each do |sub_task|
      output_task(sub_task, level + 1)
    end

    puts if root?(level)
  end

  def root?(level)
    level.zero?
  end
end
