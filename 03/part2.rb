#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

instructions = []
input.each do |line|
  instructions += line.scan(/(don't\(\)|mul\([0-9]{1,3},[0-9]{1,3}\)|do\(\))/).flatten
end

enabled = true
answer = 0
instructions.each do |instruction|
  if instruction == "don't()"
    enabled = false
  elsif instruction == 'do()'
    enabled = true
  elsif enabled
    n1, n2 = instruction.scan(/mul\(([0-9]{1,3}),([0-9]{1,3})\)/).flatten
    answer += n1.to_i * n2.to_i
  end
end

puts "Answer: #{answer}"
