# frozen_string_literal: true

# Derived Values are items in an estimate that aren't based on an actual
# estimate. Rather, they are calculated based on the other tasks in the
# estimate.
#
# Must adhere to the same interface as Task
class DerivedValue
  attr_accessor :parent
  attr_reader :name

  def filter_tasks(*)
    # A derived value by default has no subtasks
    []
  end

  def initialize(name, calculation)
    @calculation = calculation
    @name = name
  end

  def max_hours(with_derived:)
    calculation.max_hours(parent, :with_derived => with_derived)
  end

  def min_hours(with_derived:)
    calculation.min_hours(parent, :with_derived => with_derived)
  end

  def tasks
    # A derived value by default has no subtasks
    []
  end

  private

  attr_reader :calculation
end
