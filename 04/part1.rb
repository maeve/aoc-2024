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
    next unless grid[row_index][col_index] == 'X'

    if row_index - 3 >= 0
      # Upper diagonal to the left
      if col_index - 3 >= 0 &&
         grid[row_index - 1][col_index - 1] == 'M' &&
         grid[row_index - 2][col_index - 2] == 'A' &&
         grid[row_index - 3][col_index - 3] == 'S'
        matches += 1
      end

      # Straight up
      if grid[row_index - 1][col_index] == 'M' &&
         grid[row_index - 2][col_index] == 'A' &&
         grid[row_index - 3][col_index] == 'S'
        matches += 1
      end

      # Upper diagonal to the right
      if col_index + 3 < grid[row_index].size &&
         grid[row_index - 1][col_index + 1] == 'M' &&
         grid[row_index - 2][col_index + 2] == 'A' &&
         grid[row_index - 3][col_index + 3] == 'S'
        matches += 1
      end
    end

    if row_index + 3 < grid.size
      # Down diagonal to the left
      if col_index - 3 >= 0 &&
         grid[row_index + 1][col_index - 1] == 'M' &&
         grid[row_index + 2][col_index - 2] == 'A' &&
         grid[row_index + 3][col_index - 3] == 'S'
        matches += 1
      end

      # Straight down
      if grid[row_index + 1][col_index] == 'M' &&
         grid[row_index + 2][col_index] == 'A' &&
         grid[row_index + 3][col_index] == 'S'
        matches += 1
      end

      # Down diagonal to the right
      if col_index + 3 < grid[row_index].size &&
         grid[row_index + 1][col_index + 1] == 'M' &&
         grid[row_index + 2][col_index + 2] == 'A' &&
         grid[row_index + 3][col_index + 3] == 'S'
        matches += 1
      end
    end

    # Search to the left
    if col_index - 3 >= 0 &&
       grid[row_index][col_index - 1] == 'M' &&
       grid[row_index][col_index - 2] == 'A' &&
       grid[row_index][col_index - 3] == 'S'
      matches += 1
    end

    # Search to the right
    if col_index + 3 < grid[row_index].size &&
       grid[row_index][col_index + 1] == 'M' &&
       grid[row_index][col_index + 2] == 'A' &&
       grid[row_index][col_index + 3] == 'S'
      matches += 1
    end
  end
end

puts "Matches: #{matches}"
