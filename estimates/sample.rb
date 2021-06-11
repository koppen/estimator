#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../estimator/derive"
require_relative "../estimator/estimate"
require_relative "../estimator/renderer"

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
      t.derived("Unexpected", Derive.percent_of_total(25))
    end
  end

  e.derived("Project management", Derive.percent_of_total(50))
  e.derived("Quality assurance", Derive.per_task(0.5, 1))
  e.derived("Unexpected", Derive.percent_of_total(10))
end

renderer = Renderer.new(estimate)
renderer.output
