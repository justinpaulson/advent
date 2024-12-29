require '../../grid.rb'
ARGV[0] ||= "input"
GRID_SIZE = ARGV[0] == "input" ? 220 : 12
input = IO.read(ARGV[0]).chomp[1..-2]

def distance a, b
  return (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

@g = Grid.new(GRID_SIZE + 1, GRID_SIZE + 1, "#")

0.upto(GRID_SIZE) do |y|
  0.upto(GRID_SIZE) do |x|
    if y.even? || x.even?
      @g.grid[y][x] = "#"
    end
  end
end

@start = [GRID_SIZE / 2 + 1, GRID_SIZE / 2 + 1]
@min_y = GRID_SIZE
@min_x = GRID_SIZE
@max_y = 0
@max_x = 0

@g.grid[@start[0]][@start[1]] = "X"

position = @start.clone
build_input = input.clone
branches = []
while build_input.length > 0
  c = build_input.slice!(0)
  case c
  when "N"
    @g.grid[position[0]-1][position[1]] = "-"
    position = [position[0]-2, position[1]]
  when "S"
    @g.grid[position[0]+1][position[1]] = "-"
    position = [position[0]+2, position[1]]
  when "E"
    @g.grid[position[0]][position[1]+1] = "|"
    position = [position[0], position[1]+2]
  when "W"
    @g.grid[position[0]][position[1]-1] = "|"
    position = [position[0], position[1]-2]
  when "("
    branches.push(position.clone)
  when "|"
    position = branches.last.clone
  when ")"
    position = branches.pop
  end
  if position[0] < @min_y
    @min_y = position[0]
  end
  if position[0] > @max_y
    @max_y = position[0]
  end
  if position[1] < @min_x
    @min_x = position[1]
  end
  if position[1] > @max_x
    @max_x = position[1]
  end

  @g.grid[position[0]][position[1]] = "."
end

def get_neighbors point, path
  neighbors = []
  y = point[0]
  x = point[1]
  if @g.grid[y-1][x] == "-"
    neighbors << [y-2, x]
  end
  if @g.grid[y+1][x] == "-"
    neighbors << [y+2, x]
  end
  if @g.grid[y][x-1] == "|"
    neighbors << [y, x-2]
  end
  if @g.grid[y][x+1] == "|"
    neighbors << [y, x+2]
  end

  neighbors.select{|n| !path.include?(n)}
end

@greater_points = []

def bfs_max(start)
  visited = {}
  visited[start] = 0

  queue = [start]

  max_dist = 0

  until queue.empty?
    current = queue.shift
    current_dist = visited[current]

    max_dist = [max_dist, current_dist].max

    get_neighbors(current, visited.keys).each do |neighbor|
      visited[neighbor] = current_dist + 1
      if visited[neighbor] >= 1000
        @greater_points << neighbor
      end
      queue.push(neighbor)
    end
  end

  max_dist
end

puts bfs_max(@start)

puts @greater_points.uniq.length
