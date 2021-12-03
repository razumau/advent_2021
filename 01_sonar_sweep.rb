require_relative "utils"

def count_increases(depths)
  previous = depths.first
  depths[1..-1].reduce(0) do |count, depth|
    if depth > previous
      count += 1
    end
    previous = depth
    count
  end
end



def count_window_increases(depths)
  windows = (0..depths.size - 3).map do |index|
    depths[index] + depths[index + 1] + depths[index + 2]
  end
  count_increases(windows)
end

depths = Utils.read_integers("input/01.txt")

puts count_increases(depths)
puts count_window_increases(depths)
