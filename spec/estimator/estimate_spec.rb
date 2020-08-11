# frozen_string_literal: true

require "spec_helper"

require_relative "../../estimator/derive"
require_relative "../../estimator/estimate"

RSpec.describe Estimate do
  it "can be initialized" do
    expect(subject).to be_instance_of(described_class)
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

  describe "full estimate" do
    subject {
      estimate = Estimate.new
      estimate.days_per_iteration = 4
      estimate.hours_per_day = 5
      estimate.price_per_day = 1_234

      estimate.build do |e|
        e.task("Phase 1: Kickoff") do |p|
          p.task("Application setup", 2, 4)

          p.task("Server setup") do |t|
            t.task("Production server", 2, 4)
            t.task("Staging server", 2, 4)
            t.task("Email delivery", 1, 2)
          end

          p.task("Core functionality") do |t|
            t.task("God model", 4, 7)
            t.derived("Unforeseen", Derive.percent_of_total(25))
          end
        end

        e.derived("Project management", Derive.percent_of_total(50))
        e.derived("Quality assurance", Derive.per_task(0.5, 1))
        e.derived("Unforeseen", Derive.percent_of_total(10))
      end

      estimate
    }

    it "calculates hours without derived values" do
      expect(subject.hours(:with_derived => false)).to eq(Range.new(11, 21))
    end

    it "calculates hours with derived values" do
      expect(subject.hours(:with_derived => true)).to eq(Range.new(19.5, 36))
    end
  end
end
