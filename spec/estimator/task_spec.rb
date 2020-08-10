# frozen_string_literal: true

require "spec_helper"

require_relative "../../estimator/task"

RSpec.describe Task do
  it "can be initialized" do
    expect(
      described_class.new("Name of the task", 12, 23)
    ).to be_instance_of(described_class)
  end
end
