require_relative "task_builder"

class EstimateBuilder
  attr_reader :estimate

  def initialize(estimate)
    @estimate = estimate
  end

  def task(name, min_hours = nil, max_hours = nil)
    task = TaskBuilder.build(name, min_hours, max_hours)
    yield TaskBuilder.new(task) if block_given?
    estimate.add_task(task)
    task
  end
end
