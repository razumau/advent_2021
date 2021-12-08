require_relative "utils"

def find_position(crabs)
  min_fuel = Float::INFINITY
  (crabs.min..crabs.max).each do |position|
    min_fuel = [crabs.reduce(0) { |sum, crab| sum + (position - crab).abs }, min_fuel ].min
  end
  min_fuel
end

def find_position_with_increase(crabs)
  min_fuel = Float::INFINITY
  (crabs.min..crabs.max).each do |position|
    min_fuel = [ calculate_fuel_for_position(crabs, position), min_fuel ].min
  end
  min_fuel
end

def calculate_fuel_for_position(crabs, position)
  crabs.reduce(0) do |sum, crab|
    distance = (crab - position).abs
    sum + (distance * (distance + 1) / 2)
  end
end

def fuel_to_align(lines)
  find_position(lines.first.split(",").map(&:to_i))
end

def fuel_to_align_with_increase(lines)
  find_position_with_increase(lines.first.split(",").map(&:to_i))
end

p fuel_to_align(Utils::read_lines("input/07.txt"))
p fuel_to_align_with_increase(Utils::read_lines("input/07.txt"))
