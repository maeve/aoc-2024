#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

orig_pairs = input.map { |line| line.gsub(/\s+/, ' ').split(' ').map(&:to_i) }

left_list = orig_pairs.map(&:first).sort
right_list = orig_pairs.map(&:last).sort

sorted_pairs = left_list.zip(right_list)

distance = sorted_pairs.map { |left, right| (right - left).abs }.sum

puts "Answer: #{distance}"
