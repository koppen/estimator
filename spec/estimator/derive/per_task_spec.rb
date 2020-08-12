# frozen_string_literal: true

require "spec_helper"

require_relative "../../../estimator/derive"
require_relative "../../../estimator/estimate"

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
      expect(subject.min_hours(estimate, :with_derived => true)).to eq(0)
    end

    it "adds 0 hours to max_hours" do
      expect(subject.max_hours(estimate, :with_derived => true)).to eq(0)
    end
  end

  context "when estimate has tasks" do
    let(:tasks) {
      [:task1, :task2]
    }

    it "adds the minimum value for each task" do
      expect(subject.min_hours(estimate, :with_derived => true)).to eq(2)
    end

    it "adds the maximum value for each task" do
      expect(subject.max_hours(estimate, :with_derived => true)).to eq(3.5)
    end

    it "only counts tasks on the same nesting level" do
      estimate = Estimate.new
      estimate.build do |e|
        e.task("Same level") do |t|
          t.task("Nested below", 1, 2)
        end
      end

      expect(subject.min_hours(estimate, :with_derived => true)).to eq(1)
    end

    context "added to a Task" do
      it "counts the sub tasks in the task only" do
        estimate = Estimate.new
        estimate.build do |e|
          e.task("Same level") do |t|
            t.task("Nested below", 1, 2)
            t.task("Nested below", 1, 2)
          end

          e.task("Nested below", 1, 2)
          e.task("Nested below", 1, 2)
        end

        task = estimate.tasks.first

        aggregate_failures do
          expect(subject.min_hours(task, :with_derived => true)).to eq(2)
          expect(subject.max_hours(task, :with_derived => true)).to eq(3.5)
        end
      end
    end
  end
end
