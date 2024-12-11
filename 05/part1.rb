#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

ordering_rules = []
updates = []

input.each do |line|
  if line.include?('|')
    ordering_rules << line.split('|')
  elsif line.include?(',')
    updates << line.split(',')
  end
end

ordered_updates = updates.select do |update|
  update.all? do |page|
    ordering_rules.all? do |rule|
      !rule.include?(page) ||
        (other_page = rule.find { |p| p != page }) &&
          (!update.include?(other_page) ||
          update.index(rule.first) < update.index(rule.last))
    end
  end
end

middles = ordered_updates.map { |update| update[update.size / 2].to_i }

puts "Answer: #{middles.sum}"
