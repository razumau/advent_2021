require_relative "utils"

class School
  DAYS_BEFORE_GIVING_BIRTH = 6
  DAYS_BEFORE_CYCLE_STARTS = 2

  def initialize(line)
    @counter = line.split(",").map(&:to_i).each_with_object(Hash.new(0)) { |day, counter| counter[day] += 1 }
  end

  def go_to_next_day
    new_counter = Hash.new(0)
    @counter.each do |day, count|
      if day == 0
        new_counter[DAYS_BEFORE_GIVING_BIRTH + DAYS_BEFORE_CYCLE_STARTS] += count
        new_counter[DAYS_BEFORE_GIVING_BIRTH] += count
      else
        new_counter[day - 1] += count
      end
    end
    @counter = new_counter
  end

  def count
    @counter.values.sum
  end
end

def count_fish(lines, days)
  school = School.new(lines.first)
  days.times do |day|
    school.go_to_next_day
  end
  school.count
end

p count_fish(Utils.read_lines("input/06.txt"), 80)
p count_fish(Utils.read_lines("input/06.txt"), 256)
