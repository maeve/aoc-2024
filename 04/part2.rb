#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

grid = []

input.each do |line|
  grid << line.split('')
end

matches = 0

# Brute force search
grid.each_index do |row_index|
  grid[row_index].each_index do |col_index|
    next unless grid[row_index][col_index] == 'A'

    # Skip unless we have room for the X
    next unless row_index - 1 >= 0
    next unless row_index + 1 < grid.size
    next unless col_index - 1 >= 0
    next unless col_index + 1 < grid[row_index].size

    if [grid[row_index - 1][col_index - 1], grid[row_index + 1][col_index + 1]].sort == %w[M S] &&
       [grid[row_index - 1][col_index + 1], grid[row_index + 1][col_index - 1]].sort == %w[M S]
      matches += 1
    end
  end
end

puts "Matches: #{matches}"
