require_relative "utils"
require "set"

class Position
  attr_reader :number

  def initialize(number)
    @number = number
    @marked = false
  end

  def mark!
    @marked = true
  end

  def marked?
    @marked
  end

  def to_s
    "#{number} #{marked? ? '✓' : '✘'}"
  end
end

class Row
  def self.from_numbers(numbers)
    Row.new(numbers.map { |number| Position.new(number)})
  end

  def initialize(positions)
    @positions = positions
  end

  def complete?
    @positions.all?(&:marked?)
  end

  def mark!(number)
    @positions.each { |position| position.mark! if position.number == number }
  end

  def unmarked
    Set.new(@positions.reject(&:marked?).map(&:number))
  end

  def to_s
    @positions.map(&:to_s).join(", ")
  end
end

class BingoBoard
  def initialize(lines)
    @numbers = lines.map { |line| line.split.map(&:to_i)}
    @size = @numbers.first.size
    @rows = horizontals + verticals
  end

  def horizontals
    @numbers.map do |row|
      Row.from_numbers(row)
    end
  end

  def verticals
    (0...@size).map do |index|
      nums = @numbers.map { |row| row[index]}
      Row.from_numbers(nums)
    end
  end

  def mark!(number)
    @rows.each { |row| row.mark!(number) }
  end

  def won?
    @rows.any?(&:complete?)
  end

  def score
    @rows.map(&:unmarked).reduce(Set.new) { |set, new_numbers| set + new_numbers }.sum
  end

  def to_s
    <<~STR
    **************************
    #{@rows.map(&:to_s).join("\n")}
    **************************
    STR
  end
end

class Game
  def initialize(lines)
    @lines = lines
    @draws = lines.first.split(",").map(&:to_i)
    @boards = []
    @last_drawn = nil
    @last_winner = nil
    @winners = Set.new
    build_boards!
  end

  def build_boards!
    current_board = []
    @lines[2..-1].each do |line|
      if line == "\n"
        @boards << BingoBoard.new(current_board)
        current_board = []
      else
        current_board << line
      end
    end
  end

  def draw_next_number!
    number = @draws.delete_at(0)
    @boards.each do |board|
      board.mark!(number)
      if board.won? && !@winners.include?(board)
        @winners << board
        @last_winner = board
      end
    end
    @last_drawn = number
  end

  def has_winner?
    !@winners.empty?
  end

  def has_losers?
    @winners.size != @boards.size
  end

  def final_score_first_winner
    @winners.first.score * @last_drawn
  end

  def final_score_last_winner
    @last_winner.score * @last_drawn
  end
end

def play_bingo_first_winner(lines)
  game = Game.new(lines)
  until game.has_winner?
    game.draw_next_number!
  end
  game.final_score_first_winner
end

def play_bingo_last_winner(lines)
  game = Game.new(lines)
  while game.has_losers?
    game.draw_next_number!
  end
  game.final_score_last_winner
end

lines = Utils::read_lines("input/04.txt")
p play_bingo_first_winner(lines)
p play_bingo_last_winner(lines)
