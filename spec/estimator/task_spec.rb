# frozen_string_literal: true

require "spec_helper"

require_relative "../../estimator/task"

RSpec.describe Task do
  it "can be initialized" do
    expect(
      described_class.new("Name of the task", 12, 23)
    ).to be_instance_of(described_class)
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

    context "has no child tasks" do
      it "returns its own min_hours" do
        expect(subject.min_hours).to eq(12)
      end
    end
  end
end
