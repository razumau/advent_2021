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

def power_consumption(lines)
  columns = build_columns(lines)
  epsilon = columns.map { |column| most_common(column) }.join.to_i(2)
  gamma = columns.map { |column| least_common(column) }.join.to_i(2)
  epsilon * gamma
end

lines = Utils.read_lines("input/03.txt")
p power_consumption(lines)
