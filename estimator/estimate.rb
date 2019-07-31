require_relative "estimate_builder"
require_relative "task_list"

class Estimate
  attr_accessor \
    :days_per_iteration,
    :hours_per_day,
    :price_per_day

  include TaskList

  def build
    yield EstimateBuilder.new(self)
  end

  def days(with_derived: false)
    Range.new(
      min_hours(:with_derived => with_derived).to_f / hours_per_day,
      max_hours(:with_derived => with_derived).to_f / hours_per_day
    )
  end

  def hours_to_days(hours)
    hours.to_f / hours_per_day
  end

  def hours_to_iterations(hours)
    days = hours_to_days(hours)
    (days.to_f / days_per_iteration).ceil
  end

  def hours(with_derived: false)
    Range.new(
      min_hours(:with_derived => with_derived),
      max_hours(:with_derived => with_derived)
    )
  end

  def iterations(with_derived: false)
    return nil unless days_per_iteration
    Range.new(
      hours_to_iterations(hours(:with_derived => with_derived).first),
      hours_to_iterations(hours(:with_derived => with_derived).last)
    )
  end

  def price(with_derived: false)
    Range.new(
      days(:with_derived => with_derived).first * price_per_day,
      days(:with_derived => with_derived).last * price_per_day
    )
  end

  private

  def filter_tasks(with_derived: false)
    if with_derived
      tasks + derived_values
    else
      tasks
    end
  end

  def max_hours(with_derived: false)
    items = filter_tasks(:with_derived => with_derived)
    items.map(&:max_hours).compact.inject(&:+)
  end

  def min_hours(with_derived: false)
    items = filter_tasks(:with_derived => with_derived)
    items.map(&:min_hours).compact.inject(&:+)
  end
end

