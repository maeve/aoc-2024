#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

orig_pairs = input.map { |line| line.gsub(/\s+/, ' ').split(' ').map(&:to_i) }

left_list = orig_pairs.map(&:first).sort
right_list = orig_pairs.map(&:last).sort

score = 0

left_list.each do |left_number|
  count = right_list.select { |right_number| right_number == left_number }.size
  score += (left_number * count)
end

puts "Answer: #{score}"
