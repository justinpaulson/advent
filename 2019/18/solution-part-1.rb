require '../../grid.rb'

require 'set'

ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
grid = new_grid lines.length, lines[0].length
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    grid[y][x] = char
  end
end

def remove_door(doors, value)
  key = []
  doors = doors.select do |k|
    if k.keys.first == value
      key = k[value]
      false
    else
      true
    end
  end
  return doors, key
end

def print_board
  system 'clear'
  0.upto(100) do |y|
    line = ''
    0.upto(100) do |x|
      line += @board[[x,y]] || ' '
    end
    puts line
  end
end

def is_goal? point
  point == @goal[1]
end

def get_neighbors point, path
  neighbors = []
  [[point[0]-1, point[1]], [point[0]+1, point[1]], [point[0], point[1]-1], [point[0], point[1]+1]].each do |new_point|
    if !path.include?(new_point) && @board[new_point] != '#'
      neighbors << new_point
    end
  end
  neighbors
end

def score_for_neighbor point, neighbor
  1
end

def h point
  (@goal[1][0] - point[0] + @goal[1][1] - point[1]).abs
end

def print_a_star curr_point, lowest, neighbors, set, from, g, f
  return
  # puts "Unlocked: #{@unlocked}"
  puts "Goal: #{@goal}"
  puts "Current point: #{curr_point}"
  puts "Lowest score: #{lowest}"
  # puts "Neighbors: #{neighbors}"
  puts "Set: #{set}"
  # puts "From: #{from}"
  puts "G: #{g}"
  # puts "F: #{f}"
  key_wait
end

def h_h keys
  (@keys.length + 1 - keys.length)
end

def is_goal_goal? path
  path.length == @keys.count + 1
end

def get_neighbors_neighbors current
  keys, point = current
  # puts "Getting neighbors for #{point} with path #{path}"

  # remaining_doors = @doors.select{|door, position| !path.include?(door.downcase)}
  remaining_keys = @keys.keys - keys.to_a
  potential = @keys.select do |key, position|
    if point == key
      false
    elsif keys.include?(key)
      false
    else
      !(remaining_keys.any? do |k|
        door = k.upcase
        door_pos = @doors[door]
        key_pos = @keys[k]
        @distances[[point, key]][0].include?(door_pos) || @distances[[point, key]][0][1..-2].include?(key_pos)
      end)
    end
  end

  potential.keys
end

def score_for_neighbor_neighbor current, neighbor
  @distances[[current.last, neighbor]][1]
end

@max_low = 0
def print_a_star_star curr_path, lowest, neighbors, set, from, g, f
  # return
  # puts "Unlocked: #{@unlocked}"
  # puts "Goal: #{@goal}"
  if lowest > @max_low
    puts "Current path: #{curr_path}"
    puts "Lowest score: #{lowest}"
    puts "Neighbors: #{neighbors}"
    @max_low = lowest
  end
  # puts "Set: #{set}"
  # puts "From: #{from}"
  # puts "G: #{g}"
  # puts "F: #{f}"
  # key_wait
end

def a_star_star start
  current_keys = Set.new
  set = [[current_keys, start]]
  from = {}

  g = {}
  g[[current_keys, start]] = 0

  f = {}
  f[[current_keys, start]] = h_h(current_keys)

  while set.length > 0
    current, lowest = lowest_score f, set

    current_keys, current_location = current

    return [reconstruct_path(from,current), g[current]] if is_goal_goal?(reconstruct_path(from, current))

    set -= [current]

    neighbors = []

    neighbors = get_neighbors_neighbors(current)

    neighbors.each do |new_point|
      # puts "Checking #{new_point} as a neighbor for #{curr_path}"
      tent_g = g[current]

      tent_g += score_for_neighbor_neighbor(current, new_point)

      new_key_key = [current_keys + Set.new([new_point]), new_point]

      if !g.keys.include?(new_key_key) || tent_g <= g[new_key_key]
        from[new_key_key] = current
        g[new_key_key] = tent_g
        f[new_key_key] = tent_g + h_h(new_key_key)
        set << new_key_key if !set.include?(new_key_key)
      end
    end

    # here is a good place to print results
    print_a_star_star current, lowest, neighbors, set, from, g, f
  end

  return false
end


@board = {}
@unlocked = []
@keys = {}
@doors = {}
cursor = []

0.upto(grid[0].length - 1) do |x|
  0.upto(grid.length - 1) do |y|
    input = grid[y][x]
    @board[[y, x]] = grid[y][x]
    if /[[:upper:]]/.match(input)
      @doors[input] = [y,x]
    elsif /[[:lower:]]/.match(input)
      @keys[input] = [y,x]
    elsif input == '@'
      cursor = [y,x]
    end
  end
end

puts @doors.to_s
puts @doors.count
puts @keys.to_s
puts @keys.count
puts cursor.to_s
@distances = {}

#cached distances
IO.readlines("distances").map(&:chomp).map{|l| from, to, dist = l.split("-"); @distances[[from, to]] = eval(dist); @distances[[to, from]] = @distances[[from, to]]} if ARGV[0] == "input"

@unlocked = @keys.keys.clone

@keys.each do |key, position|
  next if @distances[[key, "@"]] || @distances[["@", key]]
  start = cursor.clone
  @goal = [key, position]
  result = a_star(start)
  @distances[["@", key]] = result
  @distances[[key, "@"]] = result
  print "@-#{key}-"
  puts result.to_s
end

@keys.each do |key, position|
  @keys.each do |goal, goal_position|
    next if key == goal
    next if @distances[[key, goal]] || @distances[[goal, key]]
    @goal = [goal, goal_position]
    result = a_star(position)
    @distances[[key, goal]] = result
    @distances[[goal, key]] = result
    print "#{key}-#{goal}-"
    puts result.to_s
  end
end

puts @distances.to_s

start = "@"

final = a_star_star(start)

puts final.to_s

# total_distance = 0

# while @unlocked.count < keys.count
#   distances = {}
#   @keys.select{|k,v| !@unlocked.include?(k)}.each do |(key, position)|
#     # puts "Locating #{key}"
#     start = cursor.clone
#     @goal = [key, position]
#     # puts "Starting at #{start} looking for #{key} at #{position}"
#     result = a_star(start)
#     if result
#       distances[key] = result
#     else
#       distances[key] = [[], 999999]
#     end
#     # puts "Distance to #{key}: #{distances[key]}"
#   end
#   #find shortest distance
#   potential = distances.select{|k,v| v.last < 999999}
#   puts "Potential next keys: #{potential.keys}"
#   shortest = distances.min_by{|k,v| v.last}
#   key = shortest.first
#   path, distance = shortest.last
#   total_distance += distance
#   @unlocked << key
#   cursor = @keys[key].clone
#   puts "Total unlocked: #{@unlocked}"
#   puts "Total distance: #{total_distance}"
# end

# puts total_distance





# 5206 too high
