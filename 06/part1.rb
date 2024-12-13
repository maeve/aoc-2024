#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Grid
  attr_reader :initial_grid, :initial_position, :initial_direction,
              :current_grid, :current_position, :current_direction

  def initialize(input)
    @initial_grid = input.map { |line| line.split('') }

    input.each_index do |row|
      col = input[row].index('^')
      next unless col

      @initial_position = [row, col]
      @initial_direction = :up
      break
    end

    reset_current
  end

  def reset_current
    @current_direction = initial_direction.dup
    @current_grid = initial_grid.map(&:dup)
    visit(*initial_position)
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
    current_grid[row][col] == '#'
  end

  def off_grid?(row, col)
    row.negative? || row >= current_grid.size ||
      col.negative? || col >= current_grid[0].size
  end

  def next_position
    row, col = current_position

    case current_direction
    when :up then row -= 1
    when :down then row += 1
    when :left then col -= 1
    when :right then col += 1
    end

    [row, col]
  end

  def visit(row, col)
    current_grid[row][col] = 'X'
    @current_position = [row, col]
  end

  TURNS = {
    up: :right,
    right: :down,
    down: :left,
    left: :up
  }.freeze

  def turn
    @current_direction = TURNS[current_direction]
  end

  def print
    current_grid.each { |line| puts line.join('') }
  end

  def visit_count
    current_grid.flatten.count('X')
  end
end

grid = Grid.new(input)
grid.create_map

puts "Answer: #{grid.visit_count}"
