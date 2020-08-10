# frozen_string_literal: true

require "spec_helper"

require_relative "../../estimator/estimate"

RSpec.describe Estimate do
  it "can be initialized" do
    expect(
      described_class.new
    ).to be_instance_of(described_class)
  end
end
