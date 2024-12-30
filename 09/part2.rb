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
    file_id = expanded_map.compact.max

    until file_id.negative?
      file_length = expanded_map.select { |block| block == file_id }.length

      expanded_map.each_index do |i|
        break if expanded_map[i] == file_id
        next unless expanded_map[i].nil?

        has_space = expanded_map.slice(i, file_length).compact.empty?
        next unless has_space

        expanded_map.each_index do |j|
          expanded_map[j] = nil if expanded_map[j] == file_id
        end

        (0...file_length).each do |offset|
          expanded_map[i + offset] = file_id
        end

        break
      end

      file_id -= 1
    end
  end

  def checksum
    sum = 0

    expanded_map.each_index do |i|
      sum += (i * expanded_map[i]) if expanded_map[i]
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
