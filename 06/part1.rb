#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Grid
  attr_reader :grid, :current, :direction

  def initialize(input)
    @grid = input.map { |line| line.split('') }
    input.each_index do |row|
      col = input[row].index('^')
      next unless col

      visit(row, col)
      @direction = :up
      break
    end
  end

  def create_map
    loop do
      break if off_grid?(*next_position)

      if obstacle?(*next_position)
        turn
      else
        visit(*next_position)
      end
    end
  end

  def obstacle?(row, col)
    @grid[row][col] == '#'
  end

  def off_grid?(row, col)
    row.negative? || row >= grid.size ||
      col.negative? || col >= grid[0].size
  end

  def next_position
    case @direction
    when :up
      row = current[0] - 1
      col = current[1]
    when :down
      row = current[0] + 1
      col = current[1]
    when :left
      row = current[0]
      col = current[1] - 1
    when :right
      row = current[0]
      col = current[1] + 1
    end

    [row, col]
  end

  def visit(row, col)
    @current = [row, col]
    @grid[row][col] = 'X'
  end

  def turn
    @direction = 
      case @direction
      when :up then :right
      when :right then :down
      when :down then :left
      when :left then :up
      end
  end

  def print
    @grid.each { |line| puts line.join('') }
  end

  def visit_count
    @grid.flatten.count('X')
  end
end

grid = Grid.new(input)
grid.create_map

puts "Answer: #{grid.visit_count}"
