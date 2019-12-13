# frozen_string_literal: true

require_relative "task"

class TaskBuilder
  attr_reader :parent_task

  class << self
    def build(name, min_hours = nil, max_hours = nil)
      Task.new(name, min_hours, max_hours)
    end
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
