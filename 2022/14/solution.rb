require "../../grid.rb"

lines = IO.readlines("input")


max_x = 0
max_y = 0
lines.each do |line|
  points = line.split(" -> ")
  0.upto(points.length-2) do |i|
    x1, y1 = points[i].split(",").map(&:to_i)
    max_x = [max_x, x1].max
    max_y = [max_y, y1].max
  end
end

grid = new_grid max_y+3, max_x+1000

lines.each do |line|
  points = line.split(" -> ")
  0.upto(points.length-2) do |i|
    x1, y1 = points[i].split(",").map(&:to_i)
    x2, y2 = points[i+1].split(",").map(&:to_i)
    while x1 != x2 || y1 != y2
      grid[y1][x1] = "#"
      y1 += y2 > y1 ? 1 : (y2 < y1 ? -1 : 0)
      x1 += x2 > x1 ? 1 : (x2 < x1 ? -1 : 0)
    end
    grid[y2][x2] = "#"
  end
end

print_grid grid

def add_sand grid
  sand = [0,500]

  until sand[0] > 161 ||
    (grid[sand[0]+1][sand[1]] != "." && grid[sand[0]+1][sand[1]-1] != "." && grid[sand[0]+1][sand[1]+1] != ".")
    if grid[sand[0]+1][sand[1]] == "."
      sand[1] += 0
    elsif grid[sand[0]+1][sand[1]-1] == "."
      sand[1] -= 1
    else
      sand[1] += 1
    end
    sand[0] += 1
  end
  grid[sand[0]][sand[1]] = "o" if sand[0] < 163
  grid
end

def count_sand grid
  grid.map do |line|
    line.map do |cell|
      cell == "o" ? 1 : 0
    end.sum
  end.sum
end

prev_count = 0
grid = add_sand grid
new_count = 1
while new_count != prev_count
  prev_count = new_count
  grid = add_sand grid
  new_count = count_sand grid
  if new_count % 1000 == 0
    print_grid grid 
    puts new_count
  end
end

p count_sand grid