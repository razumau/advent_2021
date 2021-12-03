require_relative "utils"

def build_columns(lines)
  (0...lines.first.size - 1).map do |column_number|
    lines.map { |line| line.chars[column_number].to_i }
  end
end

def most_common(column)
  column.tally.to_a.max_by(&:last).first
end

def least_common(column)
  column.tally.to_a.min_by(&:last).first
end

def most_common_with_tiebreaker(column)
  zeroes, ones = column.tally[0], column.tally[1]
  ones >= zeroes ? 1 : 0
end

def least_common_with_tiebreaker(column)
  zeroes, ones = column.tally[0], column.tally[1]
  ones < zeroes ? 1 : 0
end

def power_consumption(lines)
  columns = build_columns(lines)
  epsilon = columns.map { |column| most_common(column) }.join.to_i(2)
  gamma = columns.map { |column| least_common(column) }.join.to_i(2)
  epsilon * gamma
end

def life_support_rating(lines)
  oxygen_rating(lines) * co2_rating(lines)
end

def oxygen_rating(lines)
  fitting = lines.clone
  index = 0
  while fitting.size > 1 do
    bit = most_common_with_tiebreaker(build_columns(fitting)[index]).to_s
    fitting.filter! { |number| number[index] == bit }
    index += 1
  end
  fitting.first.to_i(2)
end

def co2_rating(lines)
  fitting = lines.clone
  index = 0
  while fitting.size > 1 do
    bit = least_common_with_tiebreaker(build_columns(fitting)[index]).to_s
    fitting.filter! { |number| number[index] == bit }
    index += 1
  end
  fitting.first.to_i(2)
end

lines = Utils.read_lines("input/03.txt")
p power_consumption(lines)
p life_support_rating(lines)
