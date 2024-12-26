require '../../grid.rb'
ARGV[0] ||= "input"
DIFF = ARGV[0] == "test" ? 10 : 100
lines = IO.readlines(ARGV[0]).map(&:chomp)
@g = Grid.new(lines)

@start = @g.find("S")
@endpoint = @g.find("E")

def get_next point, path
  neighbors = []
  y,x = point
  [[y+1,x],[y-1,x],[y,x+1],[y,x-1]].each do |new_point|
    if @g.grid[new_point[0]][new_point[1]] != "#" && !path.include?(new_point)
      neighbors << new_point
    end
  end
  neighbors.first
end

def build_path point
  path = [point]
  while point != @endpoint
    point = get_next(point, path)
    path << point
  end
  path
end

pathway = build_path(@start)

count = 0
@g.grid.each_with_index do |row,y|
  next if y == 0 || y == @g.grid.length - 1
  row.each_with_index do |cell,x|
    next if x == 0 || x == @g.grid[0].length - 1
    if cell == "#"
      if (@g.grid[y+1][x] == "." && @g.grid[y-1][x] == ".")
        if (pathway.index([y+1,x]) - pathway.index([y-1,x])).abs - 2 >= DIFF
          count += 1
        end
      elsif (@g.grid[y][x+1] == "." && @g.grid[y][x-1] == ".")
        if (pathway.index([y,x+1]) - pathway.index([y,x-1])).abs - 2 >= DIFF
          count += 1
        end
      elsif (@g.grid[y][x-1] == "." && @g.grid[y][x+1] == "E") || (@g.grid[y][x+1] == "." && @g.grid[y][x-1] == "E")
        if (pathway.index([y,x-1]) - pathway.index([y,x+1])).abs - 2 >= DIFF
          count += 1
        end
      end
    end
  end
end

puts count

def direct_distance point1, point2
  (point1[0] - point2[0]).abs + (point1[1] - point2[1]).abs
end

def get_cheat point, point2
  return nil if (point[0] - point2[0]).abs + (point[1] - point2[1]).abs > 20
  path = [point]

  @endtest = point2.dup

  if result = direct_distance(point, point2)
    result
  else
    nil
  end
end

count = 0
pathway[0..-DIFF-2].each_with_index do |point, i|
  pathway[i+DIFF..-1].each_with_index do |point2, j|
    ji = i + j + DIFF
    if direct_distance(point, point2) > 20
      next
    end
    cheat_distance = get_cheat(point, point2)
    next unless cheat_distance && cheat_distance <= 20
    savings = (pathway.length - 1) - (i + cheat_distance + pathway.length - 1 - ji)
    if savings >= DIFF
      count += 1
    end
  end
end

puts count
