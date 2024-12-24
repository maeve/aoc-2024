#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Node
  include Enumerable

  attr_reader :value, :threshold, :sum, :product, :combined

  def initialize(value:, threshold:)
    @value = value
    @threshold = threshold
  end

  def each(&block)
    block.call(self)
    sum&.each(&block)
    product&.each(&block)
    combined&.each(&block)
  end

  def <=>(other)
    value <=> other.value
  end

  def leaf?
    sum.nil? && product.nil? && combined.nil?
  end

  def add(operand)
    result = value + operand
    @sum = Node.new(value: result, threshold:) if result <= threshold
  end

  def multiply(operand)
    result = value * operand
    @product = Node.new(value: result, threshold:) if result <= threshold
  end

  def concatenate(operand)
    result = "#{value}#{operand}".to_i
    @combined = Node.new(value: result, threshold:) if result <= threshold
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

    @root = Node.new(value: operands.first, threshold: test_value)

    build_tree(operands[1..])
  end

  def valid?
    root.any? { |node| node.value == test_value }
  end

  private

  def build_tree(operands)
    operands.each do |operand|
      root.select(&:leaf?).each do |node|
        node.add(operand)
        node.multiply(operand)
        node.concatenate(operand)
      end
    end
  end
end

equations = input.map { |line| Equation.new(line) }
answer = equations.select(&:valid?).map(&:test_value).sum

puts "Answer: #{answer}"
