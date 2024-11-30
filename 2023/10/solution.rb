require "../../grid"
require "set"
@checked = {}
@already_flooded = Set.new
@flood_fill_queue = []
def flood_fill grid, y, x, char
  @checked[[y,x]] ||= 0
  @checked[[y,x]] += 1
  if grid[y][x] != "."
    return
  end

  grid[y][x] = char

  # print_grid grid
  @already_flooded << [y, x]
  @flood_fill_queue << [y + 1, x] if y + 1 < grid.length && !@already_flooded.include?([y+1,x])
  @already_flooded << [y + 1, x]
  @flood_fill_queue << [y - 1, x] if y - 1 >= 0 && !@already_flooded.include?([y-1,x])
  @already_flooded << [y - 1, x]
  @flood_fill_queue << [y, x + 1] if x + 1 < grid[y].length && !@already_flooded.include?([y,x+1])
  @already_flooded << [y, x + 1]
  @flood_fill_queue << [y, x - 1] if x - 1 >= 0 && !@already_flooded.include?([y,x-1])
  @already_flooded << [y, x - 1]
end

ARGV[0] ||= "input"

lines = IO.readlines(ARGV[0]).map(&:chomp)

grid = new_grid lines.length, lines[0].length

path = []

lines.each_with_index do |line, y|
  line.chomp.chars.each_with_index do |char, x|
    grid[y][x] = char
    path << [y,x] if char == "S"
  end
end

cursor = [path[0][0] + 1, path[0][1]]

while grid[cursor[0]][cursor[1]] != "S"
  last_cursor = path[-1].clone

  path << cursor.clone

  in_side = ""

  if last_cursor[0] == cursor[0]
    if last_cursor[1] < cursor[1]
      in_side = "L"
    else
      in_side = "R"
    end
  else
    if last_cursor[0] < cursor[0]
      in_side = "U"
    else
      in_side = "D"
    end
  end

  current_pipe = grid[cursor[0]][cursor[1]]

  case in_side
  when "U"
    if current_pipe == "|"
      cursor[0] += 1
    elsif current_pipe == "L"
      cursor[1] += 1
    elsif current_pipe == "J"
      cursor[1] -= 1
    end
  when "D"
    if current_pipe == "|"
      cursor[0] -= 1
    elsif current_pipe == "F"
      cursor[1] += 1
    elsif current_pipe == "7"
      cursor[1] -= 1
    end
  when "L"
    if current_pipe == "-"
      cursor[1] += 1
    elsif current_pipe == "J"
      cursor[0] -= 1
    elsif current_pipe == "7"
      cursor[0] += 1
    end
  when "R"
    if current_pipe == "-"
      cursor[1] -= 1
    elsif current_pipe == "L"
      cursor[0] -= 1
    elsif current_pipe == "F"
      cursor[0] += 1
    end
  end
end


puts path.length / 2

0.upto(grid.length - 1) do |y|
  0.upto(grid[y].length - 1) do |x|
    grid[y][x] = "." unless path.include?([y,x])
  end
end

print_grid grid

big_grid = new_grid grid.length * 3, grid[0].length * 3
grid.each_with_index do |line, little_y|
  y = little_y * 3 + 1
  line.each_with_index do |char, little_x|
    x = little_x * 3 + 1
    if char == "."
      big_grid[y-1][x-1] = "."
      big_grid[y-1][x] = "."
      big_grid[y-1][x+1] = "."
      big_grid[y][x-1] = "."
      big_grid[y][x] = "."
      big_grid[y][x+1] = "."
      big_grid[y+1][x-1] = "."
      big_grid[y+1][x] = "."
      big_grid[y+1][x+1] = "."
    elsif char == "|"
      big_grid[y-1][x-1] = "."
      big_grid[y-1][x] = "|"
      big_grid[y-1][x+1] = "."
      big_grid[y][x-1] = "."
      big_grid[y][x] = "|"
      big_grid[y][x+1] = "."
      big_grid[y+1][x-1] = "."
      big_grid[y+1][x] = "|"
      big_grid[y+1][x+1] = "."
    elsif char == "-"
      big_grid[y-1][x-1] = "."
      big_grid[y-1][x] = "."
      big_grid[y-1][x+1] = "."
      big_grid[y][x-1] = "-"
      big_grid[y][x] = "-"
      big_grid[y][x+1] = "-"
      big_grid[y+1][x-1] = "."
      big_grid[y+1][x] = "."
      big_grid[y+1][x+1] = "."
    elsif char == "J"
      big_grid[y-1][x-1] = "."
      big_grid[y-1][x] = "|"
      big_grid[y-1][x+1] = "."
      big_grid[y][x-1] = "-"
      big_grid[y][x] = "J"
      big_grid[y][x+1] = "."
      big_grid[y+1][x-1] = "."
      big_grid[y+1][x] = "."
      big_grid[y+1][x+1] = "."
    elsif char == "L"
      big_grid[y-1][x-1] = "."
      big_grid[y-1][x] = "|"
      big_grid[y-1][x+1] = "."
      big_grid[y][x-1] = "."
      big_grid[y][x] = "L"
      big_grid[y][x+1] = "-"
      big_grid[y+1][x-1] = "."
      big_grid[y+1][x] = "."
      big_grid[y+1][x+1] = "."
    elsif char == "F"
      big_grid[y-1][x-1] = "."
      big_grid[y-1][x] = "."
      big_grid[y-1][x+1] = "."
      big_grid[y][x-1] = "."
      big_grid[y][x] = "F"
      big_grid[y][x+1] = "-"
      big_grid[y+1][x-1] = "."
      big_grid[y+1][x] = "|"
      big_grid[y+1][x+1] = "."
    elsif char == "7"
      big_grid[y-1][x-1] = "."
      big_grid[y-1][x] = "."
      big_grid[y-1][x+1] = "."
      big_grid[y][x-1] = "-"
      big_grid[y][x] = "7"
      big_grid[y][x+1] = "."
      big_grid[y+1][x-1] = "."
      big_grid[y+1][x] = "|"
      big_grid[y+1][x+1] = "."
    elsif char == "S" && ARGV[0] == "input"
      big_grid[y-1][x-1] = "."
      big_grid[y-1][x] = "|"
      big_grid[y-1][x+1] = "."
      big_grid[y][x-1] = "."
      big_grid[y][x] = "|"
      big_grid[y][x+1] = "."
      big_grid[y+1][x-1] = "."
      big_grid[y+1][x] = "|"
      big_grid[y+1][x+1] = "."
    elsif char == "S" && ARGV[0] == "test"
      big_grid[y-1][x-1] = "."
      big_grid[y-1][x] = "."
      big_grid[y-1][x+1] = "."
      big_grid[y][x-1] = "."
      big_grid[y][x] = "F"
      big_grid[y][x+1] = "-"
      big_grid[y+1][x-1] = "."
      big_grid[y+1][x] = "|"
      big_grid[y+1][x+1] = "."
    end
  end
end

print_grid big_grid
puts big_grid.length * big_grid[0].length
sleep 5

@flood_fill_queue << [0, 0]
while @flood_fill_queue.length > 0
  flood_fill big_grid, *@flood_fill_queue.shift, "#"
end

print_grid big_grid

big_grid.each_slice(3).each_with_index do |(top, middle, bottom), y|
  middle.each_slice(3).each_with_index do |(left, value, right), x|
    grid[y][x] = value
  end
end

print_grid grid

total = 0

grid.each do |line|
  line.each do |char|
    total += 1 if char == "."
  end
end

puts total

puts @checked.select { |k,v| v > 1 }.length


# too low
# 556

# wrong
# 620

# too high
# 812
# 843
