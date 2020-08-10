# frozen_string_literal: true

require "spec_helper"

require_relative "../../estimator/derive"
require_relative "../../estimator/derived_value"
require_relative "../../estimator/task"

RSpec.describe Task do
  subject {
    described_class.new("Name of the task", 12, 23)
  }

  it "can be initialized" do
    expect(subject).to be_instance_of(described_class)
  end

  it "quacks like a Task" do
    expect(subject).to respond_to(:filter_tasks, :tasks)
  end

  describe "#min_hours" do
    context "has child tasks" do
      before do
        subject.add_task(Task.new("Something", 2, 4))
        subject.add_task(Task.new("Something else", 3, 5))
      end

      it "returns the sum of min_hours from child tasks" do
        expect(subject.min_hours).to eq(2 + 3)
      end
    end

    context "has child task and derived values" do
      before do
        subject.add_task(Task.new("Something", 2, 4))
        subject.add_derived_value(
          DerivedValue.new("Profit padding", Derive::PercentOfTotal.new(100))
        )
      end

      it "returns the sum of only child tasks" do
        expect(subject.min_hours(with_derived: false)).to eq(2)
      end

      it "returns the sum of child tasks plus derived values" do
        expect(subject.min_hours(with_derived: true)).to eq(2 + 2)
      end
    end

    context "has no child tasks" do
      it "returns its own min_hours" do
        expect(subject.min_hours).to eq(12)
      end
    end
  end
end
