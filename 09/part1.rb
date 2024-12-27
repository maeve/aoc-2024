#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./test-input.txt').map(&:chomp)

class DiskMap
  attr_reader :original_map, :expanded_map

  def initialize(input)
    @original_map = input.split('').map(&:to_i)
    @expanded_map = []
    expand_map
  end

  def expand_map
    file_id = 0
    original_map.each_index do |i|
      if i.even?
        original_map[i].times { expanded_map << file_id }
        file_id += 1
      else
        original_map[i].times { expanded_map << nil }
      end
    end
  end

  def compact
    until expanded_map.none?(&:nil?)
      block = expanded_map.pop
      next unless block

      expanded_map[expanded_map.index(nil)] = block
    end
  end

  def checksum
    sum = 0

    expanded_map.each_index do |i|
      sum += (i * expanded_map[i])
    end

    sum
  end

  def to_s
    expanded_map.map { |e| e || '.' }.join('')
  end
end

map = DiskMap.new(input.first)
map.compact
puts "Checksum: #{map.checksum}"
