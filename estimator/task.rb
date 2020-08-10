# frozen_string_literal: true

require_relative "task_list"

class Task
  attr_reader \
    :estimate,
    :name

  include TaskList

  def hours(with_derived: false)
    Range.new(
      min_hours(:with_derived => with_derived),
      max_hours(:with_derived => with_derived)
    )
  end

  def initialize(name, min_hours = nil, max_hours = nil)
    @name = name
    @min_hours = min_hours
    @max_hours = max_hours
  end

  def max_hours(with_derived: false)
    if tasks.any?
      tasks.map(&:max_hours).compact.inject(&:+)
    else
      @max_hours
    end
  end

  def min_hours(with_derived: false)
    tasks = filter_tasks(:with_derived => with_derived)
    if tasks.any?
      tasks.map(&:min_hours).compact.inject(&:+)
    else
      @min_hours
    end
  end

  def task(name, min_hours, max_hours)
    if block_given?
      yield self
    else
      add_task(Task.new(name, min_hours, max_hours))
    end
  end
end
