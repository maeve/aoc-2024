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

unordered_updates = updates.reject do |update|
  update.all? do |page|
    rules.all? do |rule|
      !rule.include?(page) ||
        (other_page = rule.find { |p| p != page }) &&
          (!update.include?(other_page) ||
          update.index(rule.first) < update.index(rule.last))
    end
  end
end

sorted_updates = unordered_updates.map do |update|
  ordered_update = []

  update.each do |page|
    min_index = rules.map do |rule|
      ordered_update.rindex(rule.first) if rule.last == page
    end.compact.sort.max

    max_index = rules.map do |rule|
      ordered_update.index(rule.last) if rule.first == page
    end.compact.sort.min

    if max_index.nil?
      ordered_update << page
    elsif min_index.nil?
      ordered_update.unshift(page)
    else
      ordered_update.insert(min_index.to_i + 1, page)
    end
  end

  ordered_update
end

middles = sorted_updates.map { |u| u[u.size / 2].to_i }

puts "Answer: #{middles.sum}"
