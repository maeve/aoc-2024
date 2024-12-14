#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Grid
  class Pointer
    attr_accessor :row, :col, :direction

    def initialize(row:, col:, direction:)
      self.direction = direction
      visit(row, col)
    end

    def visit(row, col)
      self.row = row
      self.col = col
    end

    def ==(other)
      row == other.row &&
        col == other.col &&
        direction == other.direction
    end

    def next_position
      next_row = row
      next_col = col

      case direction
      when :up then next_row -= 1
      when :down then next_row += 1
      when :left then next_col -= 1
      when :right then next_col += 1
      end

      [next_row, next_col]
    end

    TURNS = {
      up: :right,
      right: :down,
      down: :left,
      left: :up
    }.freeze

    def turn
      @direction = TURNS[direction]
    end
  end

  attr_reader :initial_grid, :current_grid, :start, :tortoise, :hare

  def initialize(input)
    @initial_grid = input.map { |line| line.split('') }

    input.each_index do |row|
      col = input[row].index('^')
      next unless col

      @start = Pointer.new(row:, col:, direction: :up)
      break
    end
  end

  def reset_current
    @current_grid = initial_grid.map(&:dup)
    @tortoise = Pointer.new(row: start.row, col: start.col, direction: start.direction)
    @hare = Pointer.new(row: start.row, col: start.col, direction: start.direction)
  end

  def cycle_count
    cycle_count = 0

    initial_grid.each_index do |row|
      initial_grid[0].each_index do |col|
        next if start.row == row && start.col == col

        reset_current
        current_grid[row][col] = '#'

        cycle_count += 1 if detect_cycle?
      end
    end

    cycle_count
  end

  # Simplistic version of Floyd's tortoise and hare algorithm for cycle
  # detection
  def detect_cycle?
    loop do
      return false unless move(tortoise)
      return false unless move(hare)
      return false unless move(hare)

      return true if tortoise == hare
    end
  end

  def move(pointer)
    return false if off_grid?(*pointer.next_position)

    if obstacle?(*pointer.next_position)
      pointer.turn
    else
      pointer.visit(*pointer.next_position)
    end

    true
  end

  def obstacle?(row, col)
    current_grid[row][col] == '#'
  end

  def off_grid?(row, col)
    row.negative? || row >= current_grid.size ||
      col.negative? || col >= current_grid[0].size
  end
end

grid = Grid.new(input)
puts "Answer: #{grid.cycle_count}"
