#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

pairs = []
input.each do |line|
  pairs += line.scan(/^(?:(?:(?!don't\(\)|!do\(\)).)*?(?:mul\(([0-9]{1,3}),([0-9]{1,3})\))+)+/)
  puts "Pairs: #{pairs}"
  pairs += line.scan(/(?:do\(\))(?:(?:(?!don't\(\)).)*?(?:mul\(([0-9]{1,3}),([0-9]{1,3})\))+)+/)
  puts "Pairs: #{pairs}"
end
answer = pairs.map { |n1, n2| n1.to_i * n2.to_i }.sum

puts "Answer: #{answer}"
