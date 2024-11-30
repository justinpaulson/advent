require '../../grid.rb'
ARGV[0] ||= "input"

@components = {}
conns = []

IO.readlines(ARGV[0]).map(&:chomp).each do |line|
  name, connections = line.split(": ")
  connections = connections.split(" ")
  @components[name] ||= []
  @components[name] += connections
  connections.each do |conn|
    conns << [name, conn] if !conns.include?([conn, name]) && !conns.include?([name, conn])
    @components[conn] ||= []
    @components[conn] << name
  end
end

def is_goal? point
  point == @target
end

def get_neighbors point, path
  @components[point].select{|n| !path.include?(n)}
end

def score_for_neighbor point, neighbor
  1
end

def h point
  0
end

def print_a_star curr_point, lowest, neighbors, set, from, g, f
  return
end

traversal_count = {}

200.times do
  start = @components.keys.sample
  @target = @components.keys.sample

  path = a_star(start)[0]

  0.upto(path.length-2) do |i|
    (i+1).upto(path.length-1) do |j|
      key = [path[i], path[j]].sort
      traversal_count[key] ||= 0
      traversal_count[key] += 1
    end
  end
end

paths_to_remove = traversal_count.sort_by{|k,v| v}.reverse[0..2]

paths_to_remove.each do |(s, f), count|
  conns.delete([s, f])
  conns.delete([f, s])
  @components[s].delete(f)
  @components[f].delete(s)
end

loop1 = paths_to_remove[0][0][0]

total = 1
@components.keys.each do |key|
  puts total
  next if key == loop1
  total += 1 if has_path?(loop1, key)
end

puts total * (@components.keys.count-total)
