require_relative "utils"

class Submarine
  attr_reader :x, :y

  def initialize
    @x = 0
    @y = 0
  end

  def forward(steps)
    @x += steps
  end

  def up(steps)
    @y -= steps
  end

  def down(steps)
    @y += steps
  end
end

class SubmarineWithAim
  attr_reader :x, :y

  def initialize
    @x = 0
    @y = 0
    @aim = 0
  end

  def forward(steps)
    @x += steps
    @y += @aim * steps
  end

  def up(steps)
    @aim -= steps
  end

  def down(steps)
    @aim += steps
  end
end

class Command
  attr_reader :direction, :steps

  def initialize(string)
    @direction = string.split.first
    @steps = string.split.last.to_i
  end
end

def calculate_position(lines)
  commands = lines.map { |line| Command.new(line) }
  submarine = commands.each_with_object(Submarine.new) do |command, sub|
    sub.send(command.direction.to_sym, command.steps)
  end
  puts submarine.x * submarine.y
end

def calculate_position_with_aim(lines)
  commands = lines.map { |line| Command.new(line) }
  submarine = commands.each_with_object(SubmarineWithAim.new) do |command, sub|
    sub.send(command.direction.to_sym, command.steps)
  end
  puts submarine.x * submarine.y
end

lines = Utils.read_lines("input/02.txt")
puts calculate_position(lines)
puts calculate_position_with_aim(lines)
