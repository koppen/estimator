# frozen_string_literal: true

# typed: true
class Derive
  class PercentOfTotal
    def initialize(percentage)
      @percentage = Float(percentage)
    end

    def max_hours(parent)
      (parent.hours.last * percentage / 100.0).ceil
    end

    def min_hours(parent)
      (parent.hours.first * percentage / 100.0).ceil
    end

    private

    attr_reader :percentage
  end

  class PerTask
    attr_reader :min_hours_per_task
    attr_reader :max_hours_per_task

    def initialize(min_hours_per_task, max_hours_per_task)
      @min_hours_per_task = min_hours_per_task
      @max_hours_per_task = max_hours_per_task
    end

    def max_hours(estimate)
      max_hours_per_task * number_of_tasks(estimate)
    end

    def min_hours(estimate)
      min_hours_per_task * number_of_tasks(estimate)
    end

    private

    def number_of_tasks(estimate)
      estimate.tasks.size
    end
  end

  class << self
    def per_task(min_hours, max_hours)
      PerTask.new(min_hours, max_hours)
    end

    def percent_of_total(percentage)
      unless (0..100).cover?(percentage)
        raise \
          ArgumentError,
          "Expected percentage to be a number from 0 to 100. Got #{percentage}!"
      end
      PercentOfTotal.new(percentage)
    end
  end
end
