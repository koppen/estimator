# frozen_string_literal: true

require_relative "task"

class TaskBuilder
  attr_reader :parent_task

  class << self
    def build(name, min_hours = nil, max_hours = nil)
      Task.new(name, min_hours, max_hours)
    end
  end

  # Adds a derived value to the task
  def derived(name, calculation)
    derived_value = DerivedValue.new(name, calculation)
    parent_task.add_derived_value(derived_value)
  end

  def initialize(parent_task)
    @parent_task = parent_task
  end

  def task(name, min_hours = nil, max_hours = nil)
    task = TaskBuilder.build(name, min_hours, max_hours)
    yield TaskBuilder.new(task) if block_given?
    parent_task.add_task(task)
    task
  end
end
