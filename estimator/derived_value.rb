# frozen_string_literal: true

# Derived Values are items in an estimate that aren't based on an actual
# estimate. Rather, they are calculated based on the other tasks in the
# estimate.
#
# Must adhere to the same interface as Task
class DerivedValue
  attr_accessor :estimate
  attr_reader :name

  def initialize(name, calculation)
    @calculation = calculation
    @name = name
  end

  def max_hours
    calculation.max_hours(estimate)
  end

  def min_hours
    calculation.min_hours(estimate)
  end

  def tasks
    # A derived value by default has no subtasks
    []
  end

  private

  attr_reader :calculation
end
