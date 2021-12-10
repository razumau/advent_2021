require_relative "utils"

class Stack
  def initialize
    @stack = []
  end

  def push(item)
    @stack << item
  end

  def pop
    @stack.delete_at(@stack.size - 1)
  end

  def empty?
    @stack.empty?
  end
end

MAPPING = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<'
}

class Line
  attr_reader :first_illegal_character

  def initialize(string)
    @chars = string.chars
    @first_illegal_character = nil
  end

  def corrupted?
    @stack = Stack.new
    @chars.each do |char|
      if MAPPING.values.include?(char)
        @stack.push(char)
      else
        open = @stack.pop
        if open != MAPPING[char]
          @first_illegal_character = char
          return true
        end
      end
    end

    false
  end

  def completion
    raise ArgumentError if corrupted?
    result = []
    until @stack.empty?
      open = @stack.pop
      result << MAPPING.invert[open]
    end
    result
  end
end

class CorruptionScorer
  POINTS = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
  }

  def self.score(chars)
    chars.reduce(0) { |sum, char| sum + POINTS[char] }
  end
end

class CompletionScorer
  POINTS = {
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
  }

  def self.score(chars)
    chars.reduce(0) { |sum, char| 5 * sum + POINTS[char] }
  end
end

def score_corrupted(strings)
  illegal_characters = strings.map do |string|
    line = Line.new(string.strip)
    line.first_illegal_character if line.corrupted?
  end.compact
  CorruptionScorer.score(illegal_characters)
end

def score_completion(strings)
  completions = strings.map do |string|
    line = Line.new(string.strip)
    line.completion unless line.corrupted?
  end.compact
  scores = completions.map { |completion| CompletionScorer.score(completion) }
  scores.sort[scores.size / 2]
end

lines = Utils::read_lines("input/10.txt")
p score_corrupted(lines)
p score_completion(lines)
