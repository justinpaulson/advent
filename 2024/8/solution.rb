require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
g = Grid.new(lines)

antis = Grid.new(lines.length, lines[0].length, ".")

ants = {}
g.grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    if cell != "."
      ants[cell] ||= []
      ants[cell] << [y, x]
    end
  end
end

def get_possibles_1 y1, x1, y2, x2
  y_diff = (y1 - y2).abs
  x_diff = (x1 - x2).abs
  if x1 > x2
    if y1 > y2
      [[y1 + y_diff, x1 + x_diff], [y2 - y_diff, x2 - x_diff]]
    else
      [[y1 - y_diff, x1 + x_diff], [y2 + y_diff, x2 - x_diff]]
    end
  else
    if y1 > y2
      [[y1 + y_diff, x1 - x_diff], [y1 - y_diff, x2 + x_diff]]
    else
      [[y1 - y_diff, x1 - x_diff], [y2 + y_diff, x2 + x_diff]]
    end
  end
end

ants.each do |ant, locations|
  possibles = []
  locations.combination(2) do |(y1, x1), (y2, x2)|
    possibles += get_possibles_1(y1, x1, y2, x2)
  end
  count = 0
  possibles.each do |y, x|
    if y >= 0 && x >= 0 && y < lines.length && x < lines[0].length
      count += 1
      antis.grid[y][x] = "#"
    end
  end
end

puts antis.grid.flatten.count("#")

def get_possibles_2 y1, x1, y2, x2, max_y, max_x
  y_diff = (y1 - y2).abs
  x_diff = (x1 - x2).abs
  possibles = [[y1,x1], [y2, x2]]
  if x1 > x2
    if y1 > y2
      count = 1
      while y1 + y_diff * count < max_y && x1 + x_diff * count < max_x
        possibles += [[y1 + y_diff * count, x1 + x_diff * count]]
        count += 1
      end
      count = 1
      while y2 - y_diff * count >= 0 && x2 - x_diff * count >= 0
        possibles += [[y2 - y_diff * count, x2 - x_diff * count]]
        count += 1
      end
    else
      count = 1
      while y1 - y_diff * count >= 0 && x1 + x_diff * count < max_x
        possibles += [[y1 - y_diff * count, x1 + x_diff * count]]
        count +=1
      end
      count = 1
      while y1 + y_diff * count < max_y && x2 - x_diff * count >= 0
        possibles += [[y2 + y_diff * count, x2 - x_diff * count]]
        count += 1
      end
    end
  else
    if y1 > y2
      count = 1
      while y1 + y_diff * count < max_y && x1 - x_diff * count >= 0
        possibles += [[y1 + y_diff * count, x1 - x_diff * count]]
        count += 1
      end
      count = 1
      while y2 - y_diff * count >= 0 && x2 + x_diff * count < max_x
        possibles += [[y2 - y_diff * count, x2 + x_diff * count]]
        count += 1
      end
    else
      count = 1
      while y1 - y_diff * count >= 0 && x1 - x_diff * count >= 0
        possibles += [[y1 - y_diff * count, x1 - x_diff * count]]
        count += 1
      end
      count = 1
      while y2 + y_diff * count < max_y && x2 + x_diff * count < max_x
        possibles += [[y2 + y_diff * count, x2 + x_diff * count]]
        count += 1
      end
    end
  end
  possibles
end

antis = Grid.new(lines.length, lines[0].length, ".")

ants.each do |ant, locations|
  possibles = []
  locations.combination(2) do |(y1, x1), (y2, x2)|
    possibles += get_possibles_2(y1, x1, y2, x2, lines.length, lines[0].length)
  end
  count = 0
  possibles.each do |y, x|
    if y >= 0 && x >= 0 && y < lines.length && x < lines[0].length
      count += 1
      antis.grid[y][x] = "#"
    end
  end
end

combo_grid = Grid.new(lines.length, lines[0].length, ".")
0.upto(lines.length - 1) do |y|
  0.upto(lines[0].length - 1) do |x|
    combo_grid.grid[y][x] = g.grid[y][x] if g.grid[y][x] != "."
    combo_grid.grid[y][x] = antis.grid[y][x] if antis.grid[y][x] == "#"
  end
end

combo_grid.print_grid

puts antis.grid.flatten.count("#")
