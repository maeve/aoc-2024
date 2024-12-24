#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Map
  attr_reader :grid, :antennas

  def initialize(lines)
    @grid = lines.map(&:chars)
    @antennas = {}

    grid.each_index do |row|
      grid[row].each_index do |col|
        signal = grid[row][col]
        next if signal == '.'

        antennas[signal] ||= []
        antennas[signal] << [row, col]
      end
    end
  end

  def compute_antinodes
    antennas.each_value do |positions|
      positions.each_index do |i|
        positions.each_index do |j|
          next if i == j

          diff_row = positions[i].first - positions[j].first
          diff_col = positions[i].last - positions[j].last

          mark_antinode(positions[i].first + diff_row, positions[i].last + diff_col)
          mark_antinode(positions[j].first - diff_row, positions[j].last - diff_col)
        end
      end
    end
  end

  def antinode_count
    grid.map { |row| row.select { |signal| signal == '#' } }.flatten.size
  end

  def print_map
    grid.each do |row|
      puts row.join('')
    end
  end

  private

  def mark_antinode(row, col)
    return if row.negative? || row >= grid.size
    return if col.negative? || col >= grid[0].size

    grid[row][col] = '#'
  end
end

map = Map.new(input)
map.compute_antinodes

puts "Answer: #{map.antinode_count}"
