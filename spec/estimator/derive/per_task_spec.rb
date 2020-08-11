# frozen_string_literal: true

require "spec_helper"

require_relative "../../../estimator/derive"

RSpec.describe Derive::PerTask do
  let(:estimate) {
    double(:tasks => tasks)
  }

  subject {
    Derive::PerTask.new(1, 1.75)
  }

  context "when estimate has no tasks" do
    let(:tasks) {
      []
    }

    it "adds 0 hours to min_hours" do
      expect(subject.min_hours(estimate)).to eq(0)
    end

    it "adds 0 hours to max_hours" do
      expect(subject.max_hours(estimate)).to eq(0)
    end
  end

  context "when estimate has tasks" do
    let(:tasks) {
      [:task1, :task2]
    }

    it "adds the minimum value for each task" do
      expect(subject.min_hours(estimate)).to eq(2)
    end

    it "adds the maximum value for each task" do
      expect(subject.max_hours(estimate)).to eq(3.5)
    end
  end
end
