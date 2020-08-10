# frozen_string_literal: true

require "spec_helper"

require_relative "../../estimator/derived_value"

RSpec.describe DerivedValue do
  it "can be initialized" do
    expect(
      described_class.new("Name of the derived value", :calculation)
    ).to be_instance_of(described_class)
  end
end
