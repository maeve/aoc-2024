#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

# Each line of input is a report
class Report
  attr_accessor :levels

  def initialize(line)
    @levels = line.strip.split(' ').map(&:to_i)
  end

  def safe?
    return true if all_safe?(levels)

    levels.each_index do |i|
      level_set = levels.clone
      level_set.delete_at(i)
      return true if all_safe?(level_set)
    end

    false
  end

  private

  def all_increasing?(level_set)
    level_set.each_cons(2).all? { |a, b| a < b }
  end

  def all_decreasing?(level_set)
    level_set.each_cons(2).all? { |a, b| a > b }
  end

  def all_safe?(level_set)
    return false unless all_increasing?(level_set) || all_decreasing?(level_set)

    level_set.each_cons(2).all? { |a, b| (a - b).abs.between?(1, 3) }
  end
end

safe_reports = input.select { |line| Report.new(line).safe? }

puts "Answer: #{safe_reports.count}"
