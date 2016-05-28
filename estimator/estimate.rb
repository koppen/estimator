require_relative "estimate_builder"
require_relative "task_list"

class Estimate
  attr_accessor \
    :hours_per_day

  include TaskList

  class << self
    def build(hours_per_day: 6)
      estimate = Estimate.new
      estimate.hours_per_day = hours_per_day
      builder = EstimateBuilder.new(estimate)
      yield builder
      estimate
    end
  end

  def days
    Range.new(
      min_hours.to_f / hours_per_day,
      max_hours.to_f / hours_per_day
    )
  end

  def hours
    Range.new(
      min_hours,
      max_hours
    )
  end

  private

  def max_hours
    tasks.map(&:max_hours).inject(&:+)
  end

  def min_hours
    tasks.map(&:min_hours).inject(&:+)
  end
end

