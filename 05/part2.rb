#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

rules = []
updates = []

input.each do |line|
  if line.include?('|')
    rules << line.split('|')
  elsif line.include?(',')
    updates << line.split(',')
  end
end

def ordered?(update, rules)
  update.all? do |page|
    rules.all? do |rule|
      !rule.include?(page) ||
        (other_page = rule.find { |p| p != page }) &&
          (!update.include?(other_page) ||
          update.index(rule.first) < update.index(rule.last))
    end
  end
end

updates.reject! { |u| ordered?(u, rules) }

sorted_updates = updates.map do |update|
  ordered_update = []

  update.each do |page|
    matching_rules = rules.select do |rule|
      rule.include?(page) &&
        ordered_update.include?(rule.find { |p| p != page })
    end

    if matching_rules.empty?
      ordered_update << page
      next
    end

    matching_rules.each do |rule|
      other_page = rule.find { |p| p != page }
      if rule.index(page) < rule.index(other_page)
        ordered_update.unshift(page)
      else
        ordered_update.push(page)
      end
    end
  end

  ordered_update
end

middles = sorted_updates.map { |u| u[u.size / 2].to_i }

puts "Answer: #{middles.sum}"
# 4897 is too low
# 5377 is too high
# 4948 is too low
