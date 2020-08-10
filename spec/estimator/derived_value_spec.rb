# frozen_string_literal: true

require "spec_helper"

require_relative "../../estimator/derived_value"

RSpec.describe DerivedValue do
  subject {
      described_class.new("Name of the derived value", :calculation)
  }
  it "can be initialized" do
    expect(subject).to be_instance_of(described_class)
  end

  it "quacks like a Task" do
    expect(subject).to respond_to(:filter_tasks, :tasks)
  end
end
