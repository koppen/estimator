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

  def output_task(task, level = 0)
    indent = "  " * level
    puts indent + task.name
    task.tasks.each do |sub_task|
      output_task(sub_task, level + 1)
    end
    puts if level.zero?
  end
end
