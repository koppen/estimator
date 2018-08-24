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

  def days
    Range.new(
      min_hours.to_f / hours_per_day,
      max_hours.to_f / hours_per_day
    )
  end

  def hours_to_days(hours)
    hours.to_f / hours_per_day
  end

  def hours_to_iterations(hours)
    days = hours_to_days(hours)
    (days.to_f / days_per_iteration).ceil
  end

  def hours
    Range.new(
      min_hours,
      max_hours
    )
  end

  def iterations
    return nil unless days_per_iteration
    Range.new(
      hours_to_iterations(hours.first),
      hours_to_iterations(hours.last)
    )
  end

  def price
    Range.new(
      days.first * price_per_day,
      days.last * price_per_day
    )
  end

  private

  def max_hours
    tasks.map(&:max_hours).compact.inject(&:+)
  end

  def min_hours
    tasks.map(&:min_hours).compact.inject(&:+)
  end
end

