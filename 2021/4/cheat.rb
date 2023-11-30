require 'set'

class Board
  attr_accessor :rows, :marks
  def initialize(str)
    @rows = str.lines(chomp: true).map { |l| l.split(' ').map(&:to_i) }
    @marks = @rows.map { |r| r.map { false } }
  end

  def mark(num)
    @rows.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        @marks[row_idx][col_idx] = true if col == num
      end
    end
  end

  def winner?
    @marks.any? { |r| r.all? } || (0..4).any? { |idx| @marks.map { |row| row[idx] }.all? }
  end

  def score
    sum = 0
    @rows.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        sum += col.to_i if !@marks[row_idx][col_idx]
      end
    end
    sum
  end
end

numbers, boards = File.read('input').split("\n\n", 2)
numbers = numbers.split(',').map(&:to_i)
boards = boards.split("\n\n").map { |b| Board.new(b) }

# part 1
# numbers.each do |num|
#   boards.each do |board|
#     board.mark(num)
#     if board.winner?
#       puts board.score * num
#       exit
#     end
#   end
# end

# part 2
losers = Set.new((0...boards.size).to_a)
numbers.each do |num|
  round_winners = []
  boards.each_with_index do |board, idx|
    next unless losers.include?(idx)
    board.mark(num)
    if board.winner?
      puts "removing #{idx}"
      losers.delete(idx)
      round_winners.push(idx)
    end
  end

  if losers.size == 0
    puts num * boards[round_winners.first].score
    puts boards[round_winners.first].rows.to_s
    puts boards[round_winners.first].marks.to_s
    exit
  end
end

`
removing 62
17388
`