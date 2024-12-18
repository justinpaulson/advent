require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
@g = Grid.new(71,71)

lines[0..1023].each do |line|
  x,y = line.split(",").map(&:to_i)
  @g.grid[y][x] = "#"
end

start = [0,0]

@goal = [70,70]

def is_goal? point
  point == @goal
end

def get_neighbors point, path
  neighbors = []
  y,x = point
  [[y+1,x],[y-1,x],[y,x+1],[y,x-1]].each do |new_point|
    if new_point[0] >= 0 && new_point[1] >= 0 && new_point[0] < 71 && new_point[1] < 71 && @g.grid[new_point[0]][new_point[1]] != "#"
      neighbors << new_point if !path.include?(new_point)
    end
  end
  neighbors
end

def score_for_neighbor point, neighbor
  1
end

def h point, path
  (point[0] - @goal[0]).abs * 2 + (point[1] - @goal[1]).abs * 2
end

@display_grid = Grid.new(71,71)
def print_a_star curr_point, lowest, neighbors, set, from, g, f
  return
  @display_grid.grid[curr_point[0]][curr_point[1]] = "O"
  @display_grid.print_grid
  puts "Current: #{curr_point}"
  puts "Lowest: #{lowest}"
  puts "Neighbors: #{neighbors}"
  puts "Set: #{set}"
  puts "From: #{from}"
  puts "G: #{g}"
  puts "F: #{f}"
end

puts a_star(start).last

lines[1024..2499].each do |line|
  x, y = line.split(",").map(&:to_i)
  @g.grid[y][x] = "#"
end

@display_grid.grid = @g.grid.map(&:clone)
@last_add = ""

count = 2500
while answer = a_star(start)
  @display_grid.grid = @g.grid.map(&:dup)
  path = answer[0]
  x, y = lines[count].split(",").map(&:to_i)
  while !path.include?([y,x])
    count += 1
    x, y = lines[count].split(",").map(&:to_i)
    @g.grid[y][x] = "#"
    @display_grid.grid[y][x] = "#"
    @last_add = "#{x},#{y}"
  end
  @display_grid.grid[y][x] = "#"
  @last_add = "#{x},#{y}"
  @g.grid[y][x] = "#"
  count += 1
end

puts @last_add
