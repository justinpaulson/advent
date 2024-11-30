require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

corners = []
letters = {}
start = []
grid = new_grid(lines.length, lines[0].length)
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    letters[char] = [y,x] if char.match(/[A-Z]/)
    start = [y,x] if y == 0 && char == "|"
    corners << [y,x] if char == "+"
    grid[y][x] = char
  end
end

connections = {}

corners.each do |corner|
  connections[corner] ||= []
  corners.each do |other_corner|
    next if corner == other_corner
    connected = true
    if corner[0] == other_corner[0]
      [corner[1], other_corner[1]].min.upto([corner[1], other_corner[1]].max) do |x|
        connected = false if grid[corner[0]][x] == " "
      end
    elsif corner[1] == other_corner[1]
      [corner[0], other_corner[0]].min.upto([corner[0], other_corner[0]].max) do |y|
        connected = false if grid[y][corner[1]] == " "
      end
    else
      connected = false
    end
    connections[corner] << other_corner if connected
  end
end

first_corner = corners.select{|c| c[1] == start[1] }.sort_by{|c| c[0]}.first
connections[start] = [first_corner]

visited = []

current = start
output = ""
steps = 0
while current
  visited << current
  next_point = connections[current] - visited
  if next_point.count > 0
    next_point = next_point.first
  else
    next_point = nil
  end

  letters.each do |letter, point|
    if (point[0] == next_point[0] && ((next_point[1] < point[1] && current[1] > point[1]) || (next_point[1] > point[1] && current[1] < point[1]))) ||
      (point[1] == next_point[1] && ((next_point[0] < point[0] && current[0] > point[0]) || (next_point[0] > point[0] && current[0] < point[0])))
      output += letter
    end
  end if next_point

  if next_point
    if current[0] == next_point[0]
      steps += (current[1] - next_point[1]).abs
    else
      steps += (current[0] - next_point[0]).abs
    end
  end

  current = next_point
end

last_corner = visited.last
last_letter = letters[(letters.keys - output.chars).join]
if last_corner[0] == last_letter[0]
  steps += (last_corner[1] - last_letter[1]).abs
else
  steps += (last_corner[0] - last_letter[0]).abs
end

puts output + (letters.keys - output.chars).join

puts steps + 1  # add one to go off the bottom of the grid, so dumb
