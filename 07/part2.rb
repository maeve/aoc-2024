#!/usr/bin/env ruby
# frozen_string_literal: true
require 'byebug'
require 'parallel'
filename = 'input.txt'
values = []

File.open(filename) do |f|
  f.each_line do |line|
    total, rest = line.split(':')
    total = total.to_i
    parts = rest.split(' ').map(&:strip).map(&:to_i)
    values.push([total, parts])
  end
end

def check_val(total, val, parts, operations='')
  next_part = parts[0]
  rest = parts[1..] || []
  sum = next_part + val
  product = next_part * val
  concat = "#{val}#{next_part}".to_i
  results = []
  if !rest.any?
    if sum == total
      results.push(operations + '+')
    end

    if product == total
      results.push(operations + '*')
    end

    if concat == total
      results.push(operations + '|')
    end
  else
    results.concat(check_val(total, sum, rest, operations + '+'))

    results.concat(check_val(total, product, rest, operations + '*'))
    results.concat(check_val(total, concat, rest, operations + '|'))
  end

  return results
end

results = Parallel.map(values, in_processes: 24) do |value|
  total, parts = value
  results = check_val(total, 0, parts, '')
  if results.any?
    total
  else
    0
  end
end

puts results.sum
