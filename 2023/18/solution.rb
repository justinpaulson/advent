require '../../grid.rb'
require 'set'

ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

moves = []
moves_2 = []
lines.each do |line|
  moves << line.split(" ")
  moves.last[1] = moves.last[1].to_i
  moves.last[2] = moves.last[2].split("#")[1].split(")")[0]

  dir = "R"
  case moves.last[2][-1]
  when "0"
    dir = "R"
  when "1"
    dir = "D"
  when "2"
    dir = "L"
  when "3"
    dir = "U"
  end
  moves_2 << [dir, moves.last[2][0..4].to_i(16)]

end

cursor = [0, 0]

coordinates = []

def get_area vertices
  num_of_vertices = vertices.length
  sum = 0

  (-1).upto(vertices.length-2) do |index|
    sum += vertices[index][0] * vertices[(index + 1)][1] - vertices[index][1] * vertices[(index + 1)][0]
  end

  sum = sum / 2
  sum = sum.abs
  sum
end

good_coordinates = []

moves.each_with_index do |move, i|
  next_move = moves[(i+1) % moves.length][0]

  puts "I: #{i} #{move} #{next_move}"

  case move[0]
  when "R"
    coordinates << [cursor[0], cursor[1] + move[1]]
    coordinates.last[1] += 1 if next_move == "D"
    cursor[1] += move[1]
  when "L"
    coordinates << [cursor[0] + 1, cursor[1] - move[1]]
    coordinates.last[1] += 1 if next_move == "D"
    cursor[1] -= move[1]
  when "U"
    coordinates << [cursor[0] - move[1], cursor[1]]
    coordinates.last[0] += 1 if next_move == "L"
    cursor[0] -= move[1]
  when "D"
    coordinates << [cursor[0] + move[1], cursor[1] + 1]
    coordinates.last[0] += 1 if next_move == "L"
    cursor[0] += move[1]
  end

end

puts coordinates.reverse!.to_s

puts get_area(coordinates)

cursor_2 = [0, 0]

coordinates = []

puts moves_2.length

moves_2.each_with_index do |move, i|
  next_move = moves_2[(i+1) % moves_2.length][0]

  puts "I: #{i} #{move} #{next_move}"

  case move[0]
  when "R"
    coordinates << [cursor_2[0], cursor_2[1] + move[1]]
    coordinates.last[1] += 1 if next_move == "D"
    cursor_2[1] += move[1]
  when "L"
    coordinates << [cursor_2[0] + 1, cursor_2[1] - move[1]]
    coordinates.last[1] += 1 if next_move == "D"
    cursor_2[1] -= move[1]
  when "U"
    coordinates << [cursor_2[0] - move[1], cursor_2[1]]
    coordinates.last[0] += 1 if next_move == "L"
    cursor_2[0] -= move[1]
  when "D"
    coordinates << [cursor_2[0] + move[1], cursor_2[1] + 1]
    coordinates.last[0] += 1 if next_move == "L"
    cursor_2[0] += move[1]
  end
end

puts get_area(coordinates)

# no! 145625624027704
# no! 133125624027704
# no! 266251248055408
# no! 291251248055408
