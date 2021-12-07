require_relative "utils"
require "set"

class VentsMap
  def initialize
    @covered = Set.new
    @covered_twice = Set.new
  end

  def add_line(line)
    from, to = line[0...-1].split(" -> ")
    from_x, from_y = from.split(",").map(&:to_i)
    to_x, to_y = to.split(",").map(&:to_i)
    points = if from_x == to_x
               generate_range([from_y, to_y]).map{ |y| [from_x, y] }
             elsif from_y == to_y
               generate_range([from_x, to_x]).map{ |x| [x, from_y] }
             else
               []
             end
    mark_points(points)
  end

  def add_line_with_diagonals(line)
    from, to = line[0...-1].split(" -> ")
    from_x, from_y = from.split(",").map(&:to_i)
    to_x, to_y = to.split(",").map(&:to_i)
    points = if from_x == to_x
               generate_range([from_y, to_y]).map{ |y| [from_x, y] }
             elsif from_y == to_y
               generate_range([from_x, to_x]).map{ |x| [x, from_y] }
             elsif (from_x - to_x).abs == (from_y - to_y).abs
               generate_diagonal_range(from_x, from_y, to_x, to_y)
             else
               []
             end
    mark_points(points)
  end

  def generate_range(array)
    (array.min..array.max).to_a
  end

  def generate_range_unsorted(from, to)
    change = from < to ? 1 : -1
    range = []
    number = from
    ((from - to).abs + 1).times do
      range << number
      number += change
    end
    range
  end

  def generate_diagonal_range(from_x, from_y, to_x, to_y)
    xs = generate_range_unsorted(from_x, to_x)
    ys = generate_range_unsorted(from_y, to_y)
    xs.zip(ys)
  end

  def mark_points(points)
    points.each do |point|
      if @covered.include?(point)
        @covered_twice << point
      else
        @covered << point
      end
    end
  end

  def covered_twice_count
    @covered_twice.size
  end
end

def count_overlaps_without_diagonals(lines)
  map = VentsMap.new
  lines.each { |line| map.add_line(line) }
  map.covered_twice_count
end


def count_overlaps_with_diagonals(lines)
  map = VentsMap.new
  lines.each { |line| map.add_line_with_diagonals(line) }
  map.covered_twice_count
end

p count_overlaps_without_diagonals(Utils::read_lines("input/05.txt"))
p count_overlaps_with_diagonals(Utils::read_lines("input/05.txt"))