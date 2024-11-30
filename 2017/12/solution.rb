require '../../grid.rb'
require 'set'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

@programs = {}
lines.each do |line|
  prog, connections = line.split(" <-> ")
  connections = connections.split(", ").map(&:to_i)
  prog = prog.to_i
  @programs[prog] = connections
end

def get_neighbors point, path
  neighbors = []
  @programs[point].each do |neighbor|
    neighbors << neighbor if !path.include?(neighbor)
  end
  neighbors
end

def h point, path
  0
end

def score_for_neighbor point, neighbor
  1
end

def is_goal? point
  point == @goal
end

first_neighborts = @programs[0]
paths = first_neighborts.map { |neighbor| [0, neighbor] }
all_nodes = Set.new(@programs.keys)
seen = Set.new
seen << 0
while (path = paths.shift)
  curr_point = path.last
  seen << curr_point
  next if curr_point == 0
  paths += get_neighbors(curr_point, path).map { |neighbor| path + [neighbor] }
end

puts seen.length

all_nodes -= seen

total = 1
while all_nodes.length > 0
  total += 1
  @goal = all_nodes.first
  first_neighborts = @programs[@goal]
  paths = first_neighborts.map { |neighbor| [@goal, neighbor] }
  seen = Set.new
  seen << @goal
  while (path = paths.shift)
    curr_point = path.last
    seen << curr_point
    next if curr_point == @goal
    paths += get_neighbors(curr_point, path).map { |neighbor| path + [neighbor] }
  end
  all_nodes -= seen
end

puts total
