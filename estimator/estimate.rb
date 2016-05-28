require_relative "estimate_builder"
require_relative "task_list"

class Estimate
  attr_accessor \
    :hours_per_day

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

