require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

def move nodes, node, target
  # nodes[target][:used] += nodes[node][:used]
  # nodes[target][:available] -= nodes[node][:used]
  # nodes[target][:percent] = nodes[target][:used] * 100 / nodes[target][:size]
  temp_x = nodes[target][:x]
  temp_y = nodes[target][:y]
  nodes[target][:x] = nodes[node][:x]
  nodes[target][:y] = nodes[node][:y]
  # nodes[node][:used] = 0
  # nodes[node][:available] = nodes[node][:size]
  # nodes[node][:percent] = 0
  nodes[node][:x] = temp_x
  nodes[node][:y] = temp_y
  nodes
end

@nodes = {}

lines.map do |line|
  node, size, used, available, percent = line.split(" ")
  x = node.split("-")[1][1..-1].to_i
  y = node.split("-")[2][1..-1].to_i
  size = size.to_i
  used = used.to_i
  available = available.to_i
  percent = percent.to_i
  @nodes[node] = {x: x, y: y, size: size, used: used, available: available, percent: percent}
end

def viable_pairs nodes
  pairs = []
  @nodes.each do |node, info|
    next if info[:used] == 0
    @nodes.each do |other_node, other_info|
      next if node == other_node || info[:used] > other_info[:available]
      pairs << [node, other_node]
    end
  end
  pairs
end

def find_hole nodes
  pairs = []
  @nodes.each do |node, info|
    next if info[:used] == 0
    @nodes.each do |other_node, other_info|
      next if node == other_node || info[:used] > other_info[:available]
      return other_node
    end
  end
  nil
end

our_node = "/dev/grid/node-x0-y0"
goal = "/dev/grid/node-x31-y0"

def get_neighbors nodes, path
  node = find_hole(nodes)
  x = nodes[node][:x]
  y = nodes[node][:y]
  neighbors = []
  neighbors << nodes.keys.select{|n| nodes[n][:x] == x && nodes[n][:y] == y-1}.first if y > 0
  neighbors << nodes.keys.select{|n| nodes[n][:x] == x-1 && nodes[n][:y] == y}.first if x > 0
  neighbors << nodes.keys.select{|n| nodes[n][:x] == x+1 && nodes[n][:y] == y}.first if x < 31
  neighbors << nodes.keys.select{|n| nodes[n][:x] == x && nodes[n][:y] == y+1}.first if y < 29
  neighbors.select{|n| nodes[n][:used] <= nodes[node][:available] && !path.include?(n)}.map do |neighbor|
    out_nodes = move(deep_copy(nodes), neighbor, node)
    out_nodes
  end
end

def score_for_neighbor nodes, neighbor
  1
end

def is_goal? point
  nodes = point
  nodes["/dev/grid/node-x31-y0"][:x] == 0 && nodes["/dev/grid/node-x31-y0"][:y] == 0
end

def h point
  nodes = point
  dist = 0
  hole_y = nodes["/dev/grid/node-x24-y26"][:y]
  hole_x = nodes["/dev/grid/node-x24-y26"][:x]
  data_y = nodes["/dev/grid/node-x31-y0"][:y]
  data_x = nodes["/dev/grid/node-x31-y0"][:x]
  if (hole_y - data_y).abs > 1
    dist += (hole_y - data_y).abs * 1000
  end
  if (hole_y < 23) && (hole_x - data_x).abs > 1
    dist += (hole_x - data_x).abs * 20
  else
    dist += hole_x * 2
  end
  dist += (31 - (31 - (data_x))) * 20
  dist += data_x
end

def print_a_star curr_point, lowest, neighbors, set, from, g, f
  return
  puts "hole = #{curr_point["/dev/grid/node-x24-y26"][:x]} #{curr_point["/dev/grid/node-x24-y26"][:y]}"
  puts "data = #{curr_point["/dev/grid/node-x31-y0"][:x]} #{curr_point["/dev/grid/node-x31-y0"][:y]}"
  neighbors.each do |neighbor|
    puts "h of neighbot: #{h(neighbor)}"
    puts "neighbor hole: #{neighbor["/dev/grid/node-x24-y26"][:x]} #{neighbor["/dev/grid/node-x24-y26"][:y]}"
  end
  puts "lowest: #{lowest}"
end

puts viable_pairs(@nodes).size

# VERY SLOW, but works!
puts a_star(@nodes).last





# @max_goal = 0
# @queue = [[deep_copy(@nodes), 0]]
# @found = {@queue.first[0] => 0}
# while @queue.size > 0
#   puts @found.size if @found.size % 1000 == 0
#   nodes, moves = @queue.shift
#   if is_goal?(nodes)
#     if moves.size > @max_goal
#       @max_goal = moves.size
#       puts "Found goal at #{moves.size}"
#     end
#   end
#   hole = find_hole(nodes)
#   puts hole.to_s
#   puts get_neighbors(nodes, hole).to_s
#   @queue += get_neighbors(nodes, hole).map{|n| [move(deep_copy(nodes), n, hole), moves + 1]}
#   # puts @queue.to_s
#   # exit
# end

  # puts "Currents steps: #{steps}, goal: #{goal}"
  # count = 0
  # @nodes.each do |our_node, info|
  #   our_x = @nodes[our_node][:x]
  #   our_y = @nodes[our_node][:y]
  #   our_used = @nodes[our_node][:used]
  #   viable_pairs = []
  #   @nodes.each do |other_node, other_info|
  #     next if our_node == other_node
  #     if (other_info[:x] == our_x || other_info[:y] == our_y) &&
  #       !path.include?(other_node) &&
  #       our_used > 0 &&
  #       our_used <= other_info[:available]
  #       viable_pairs << [our_node, other_node]
  #       # puts other_info[:available]
  #     end
  #   end
  #   # this needs to also limit to "adjacent nodes" where x==x or y==y
  #   if viable_pairs.size == 1
  #     count += 1
  #     puts viable_pairs.to_s
  #   end
  #   # raise "oh crap" if viable_pairs.empty?
  #   # raise "oh double crap" if viable_pairs.size > 1
  #   # puts our_used
  #   # puts viable_pairs.to_s

  #   # target = viable_pairs.first[1]
  # path << target

  # move [["/dev/grid/node-x0-y26", "/dev/grid/node-x24-y26"]]
  # move [["/dev/grid/node-x0-y0", "/dev/grid/node-x0-y26"]]
  # move [["/dev/grid/node-x31-y0", "/dev/grid/node-x0-y0"]]

  # puts count
  # exit
  # move(our_node, target)

  # goal = available_pairs.first[1]



  # available_pairs = viable_pairs.select{|pair| pair[0] == goal && !path.include?(pair[1])}
#   # puts "Available pairs: #{available_pairs}"
#   # puts "Viable pairs: #{viable_pairs.size}"
# end

# puts steps
