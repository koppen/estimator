require_relative "task"

class EstimateBuilder
  attr_reader :estimate

  def initialize(estimate)
    @estimate = estimate
  end

  def task(name, min_hours = nil, max_hours = nil)
    task = Task.new(name, min_hours, max_hours)
    if block_given?
      yield task
    end
    estimate.add_task(task)
    task
  end
end
