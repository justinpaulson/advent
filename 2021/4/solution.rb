load "../../grid.rb"

def bingo? board, n
  0.upto(4) do |x|
    0.upto(4) do |y|
      board[x][y] = nil if board[x][y] == n
    end
  end

  0.upto(4) do |i|
    return true if !board[i][0] && !board[i][1] && !board[i][2] && !board[i][3] && !board[i][4]
  end

  0.upto(4) do |x|
    return true if !board[0][x] && !board[1][x] && !board[2][x] && !board[3][x] && !board[4][x]
  end

  # return true if !board[0][0] && !board[1][1] && !board[2][2] && !board[3][3] && !board[4][4]
  # return true if !board[4][0] && !board[3][1] && !board[2][2] && !board[1][3] && !board[0][4]

  false

end

def score board, num
  board_sum = board.sum{|b| b.sum{|a| a ? a : 0}}
  num * board_sum
end

lines = File.readlines("input")

nums = lines[0].split(',').map(&:to_i)

lines = lines[2..-1]

boards = []

lines.each_slice(6) do |a,b,c,d,e,_|
  board = new_grid 5,5,0
  board[0] = a.split.map(&:to_i)
  board[1] = b.split.map(&:to_i)
  board[2] = c.split.map(&:to_i)
  board[3] = d.split.map(&:to_i)
  board[4] = e.split.map(&:to_i)
  boards << board
end

print_grid boards[62], ","

wins = []
win_boards = []
win_index = []

boards.each do |board|
  nums.each_with_index do |n, i|
    (wins << n; win_boards << board; win_index << i;) if !win_boards.include?(board) && bingo?(board, n)
  end
end
puts "----------------"
print_grid boards[62], ","

ind = win_index.index(win_index.max)

print_grid win_boards[ind], ","

puts score(win_boards[ind], wins[ind])

#   11,  ,  ,36,13
# 1 78,  ,  ,  ,
# 2 56,  ,  ,  ,
# 3   ,  ,  ,  ,76
# 4   ,  ,72,  ,

# 0 91,51,90,  ,
# 1   ,35,13,  ,
# 2 89,75,  ,  ,36
# 3   ,  ,56,  ,78
# 4   ,  ,  ,69,
