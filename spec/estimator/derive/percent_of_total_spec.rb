# frozen_string_literal: true

require "spec_helper"

require_relative "../../../estimator/derive"

RSpec.describe Derive::PercentOfTotal do
  let(:estimate) {
    double(:hours => Range.new(10, 20))
  }

  it "calculates a percentage of minimum hours" do
    derived = Derive::PercentOfTotal.new(30)

    expect(derived.min_hours(estimate)).to eq(10 * 0.3)
  end

  it "calculates a percentage of maximum hours" do
    derived = Derive::PercentOfTotal.new(30)

    expect(derived.max_hours(estimate)).to eq(20 * 0.3)
  end

  it "rounds up" do
    derived = Derive::PercentOfTotal.new(25)

    expect(derived.min_hours(estimate)).to eq(3)
  end
end
