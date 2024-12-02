#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

# Each line of input is a report
class Report
  attr_accessor :levels

  def initialize(line)
    @levels = line.strip.split(' ').map(&:to_i)
  end

  def increasing?
    levels.each_cons(2).all? { |a, b| a < b }
  end

  def decreasing?
    levels.each_cons(2).all? { |a, b| a > b }
  end

  def safe?
    return false unless increasing? || decreasing?

    levels.each_cons(2).all? { |a, b| (a - b).abs.between?(1, 3) }
  end
end

safe_reports = input.select { |line| Report.new(line).safe? }

puts "Answer: #{safe_reports.count}"
