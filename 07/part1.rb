#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Node
  include Enumerable

  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
  end

  def each(&block)
    left.each(&block) if left
    block.call(self)
    right.each(&block) if right
  end

  def <=>(other_node)
    value <=> other_node.value
  end

  def leaf?
    left.nil? && right.nil?
  end

  def to_s
    value
  end
end

class Equation
  attr_reader :test_value, :root

  def initialize(input)
    parts = input.split(':')
    @test_value = parts.first.strip.to_i

    operands = parts.last.strip.split(' ').map(&:to_i)
    build_tree(operands)
  end

  def build_tree(operands)
    @root = Node.new(operands.first)

    operands[1..].each do |operand|
      leaves = root.select(&:leaf?)

      leaves.each do |node|
        sum = node.value + operand
        node.left = Node.new(sum) if sum <= test_value

        product = node.value * operand
        node.right = Node.new(product) if product <= test_value
      end
    end
  end

  def valid?
    root.any? { |node| node.value == test_value }
  end

  def to_s
    "#{test_value}: #{root.map(&:to_s).join(' ')}"
  end
end

equations = input.map { |line| Equation.new(line) }
answer = equations.select(&:valid?).map(&:test_value).sum

puts "Answer: #{answer}"
