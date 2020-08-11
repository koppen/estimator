# frozen_string_literal: true

require "spec_helper"

require_relative "../../estimator/estimate"

RSpec.describe Estimate do
  it "can be initialized" do
    expect(
      described_class.new
    ).to be_instance_of(described_class)
  end

  it "has tasks" do
    estimate = Estimate.new
    estimate.build do |e|
      e.task("Stuff", 5, 6)
      e.task("More work", 10, 20)
    end

    expect(estimate.hours).to eq(Range.new(15, 26))
  end

  it "has sub-tasks" do
    estimate = Estimate.new
    estimate.build do |e|
      e.task("Complex") do |t|
        t.task("Detailed work", 10, 20)
      end
    end

    expect(estimate.hours).to eq(Range.new(10, 20))
  end
end
