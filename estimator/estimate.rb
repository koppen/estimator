# frozen_string_literal: true

require_relative "estimate_builder"
require_relative "task_list"

class Estimate
  attr_accessor \
    :days_per_iteration,
    :hours_per_day,
    :price_per_day,
    :price_per_iteration

  include TaskList

  def build(&block)
    builder = EstimateBuilder.new(self)
    builder.instance_eval(&block)
  end

  def days(with_derived:)
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

  def hours(with_derived:)
    Range.new(
      min_hours(:with_derived => with_derived),
      max_hours(:with_derived => with_derived)
    )
  end

  def iterations(with_derived:)
    return nil unless days_per_iteration

    Range.new(
      hours_to_iterations(hours(:with_derived => with_derived).first),
      hours_to_iterations(hours(:with_derived => with_derived).last)
    )
  end

  def price(with_derived:)
    price_based_on_iterations(:with_derived => with_derived)
  end

  def price_based_on_days(with_derived:)
    Range.new(
      days(:with_derived => with_derived).first * price_per_day,
      days(:with_derived => with_derived).last * price_per_day
    )
  end

  def price_based_on_iterations(with_derived:)
    Range.new(
      iterations(:with_derived => with_derived).first * price_per_iteration,
      iterations(:with_derived => with_derived).last * price_per_iteration
    )
  end

  def to_hash(with_derived:)
    {
      :hours_low => hours(:with_derived => with_derived).first,
      :hours_high => hours(:with_derived => with_derived).last,
      :days_low => days(:with_derived => with_derived).first,
      :days_high => days(:with_derived => with_derived).last,
      :iterations_low => iterations(:with_derived => with_derived).first,
      :iterations_high => iterations(:with_derived => with_derived).last,
    }
  end

  private

  def filter_tasks(with_derived:)
    if with_derived
      tasks + derived_values
    else
      tasks
    end
  end

  def max_hours(with_derived:)
    items = filter_tasks(:with_derived => with_derived)
    items.map { |item|
      item.max_hours(:with_derived => with_derived)
    }.compact.inject(&:+)
  end

  def min_hours(with_derived:)
    items = filter_tasks(:with_derived => with_derived)
    items.map { |item|
      item.min_hours(:with_derived => with_derived)
    }.compact.inject(&:+)
  end
end
