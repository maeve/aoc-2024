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

unordered_updates = updates.reject do |update|
  update.all? do |page|
    ordering_rules.all? do |rule|
      !rule.include?(page) ||
        (other_page = rule.find { |p| p != page }) &&
          (!update.include?(other_page) ||
          update.index(rule.first) < update.index(rule.last))
    end
  end
end

sorted_updates = unordered_updates.each do |update|
  update.sort! do |a, b|
    rule = ordering_rules.find { |r| r.include?(a) && r.include?(b) }
    if rule.first == a
      update.index(a) <=> update.index(b)
    elsif rule.first == b
      update.index(b) <=> update.index(a)
    else
      0
    end
  end
end

middles = sorted_updates.map { |update| update[update.size / 2].to_i }

puts "Answer: #{middles.sum}"
# 4897 is too low
