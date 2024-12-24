require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
@g = Grid.new(lines)

@reindeer = @g.find("S")
@goal = @g.find("E")

def lowest_score scores, points
  lowest_score = 9999999
  low = [points[0],scores[points[0]]]
  points.each do |point|
    if scores[point] < lowest_score
      low = [point,scores[point]]
      lowest_score = scores[point]
    end
  end
  low
end

def reconstruct_path from, current
  total_path = [current]
  while from.keys.include?(current)
    current = from[current]
    total_path.prepend(current)
  end
  total_path
end

def is_goal? point
  point == @goal
end

@get_neighbors = {}
def get_neighbors point, path
  return @get_neighbors[[point,path]] if @get_neighbors[[point,path]]
  neighbors = []
  y,x = point
  [[y+1,x],[y-1,x],[y,x+1],[y,x-1]].each do |new_point|
    if @g.grid[new_point[0]][new_point[1]] != "#"
      neighbors << new_point if !path.include?(new_point)
    end
  end
  @get_neighbors[[point,path]] = neighbors
  @get_neighbors[[point,path]]
  neighbors
end

def score_for_neighbor last, point, neighbor
  if point == @reindeer
    return 1 if point[0] == neighbor[0]
    return 1001 if point[1] == neighbor[1]
  end
  if last[0] == point[0] && point[0] == neighbor[0]
    1
  elsif last[1] == point[1] && point[1] == neighbor[1]
    1
  else
    1001
  end
end

@h = {}
def h point, path
  return @h[point] if @h[point]
  @h[point] = (point[0] - @goal[0]).abs * 1 + (point[0] - @goal[0]).abs * 1
  @h[point]
end

def print_a_star curr_point, lowest, neighbors, set, from, g, f
  return
  puts "Lowest: #{lowest}"
  puts "Current: #{curr_point}"
  puts "Neighbors: #{neighbors}"
  puts "Set: #{set}"
  puts "From: #{from}"
  puts "G: #{g}"
  puts "F: #{f}"
end

@lowest_score = {}

def a_star start
  set = [start]
  from = {}

  g = {}
  g[start] = 0
  @lowest_score[start] = 0

  f = {}
  f[start] = h(start, [start])

  while set.length > 0
    curr_point, lowest = lowest_score f, set

    return [reconstruct_path(from,curr_point), g[curr_point]] if is_goal?(curr_point)

    set -= [curr_point]

    last = from[curr_point]

    neighbors = []

    neighbors = get_neighbors(curr_point, reconstruct_path(from, curr_point))

    neighbors.each do |new_point|
      tent_g = g[curr_point]

      tent_g += score_for_neighbor(last, curr_point, new_point)

      if !g.keys.include?(new_point) || tent_g < g[new_point]
        from[new_point] = curr_point
        g[new_point] = tent_g
        @lowest_score[new_point] = tent_g
        f[new_point] = tent_g + h(new_point, reconstruct_path(from, new_point))
        set << new_point if !set.include?(new_point)
      end
    end

    print_a_star curr_point, lowest, neighbors, set, from, g, f
  end

  return false
end

@score_path = {}
def score_path path
  return @score_path[path] if @score_path[path]
  score = 0
  if path[1][0] == @reindeer[0]
    score += 1
  else
    score += 1001
  end
  path[1..-2].each_with_index do |point, i|
    score += score_for_neighbor(path[i], path[i+1], path[i+2])
  end
  @score_path[path] = score
  @lowest_score[path.last] ||= score
  if @lowest_score[path.last] > score
    @lowest_score[path.last] = score
  end
  @score_path[path]
end

def all_shortest_paths correct
  next_path = [[[@reindeer[0], @reindeer[1]]]]
  all_paths = []
  while next_path.any?
    current_path = next_path.shift
    if current_path.last == @goal
      all_paths << current_path
      next
    end


    possible_next_positions = get_neighbors(current_path.last, current_path)
    possible_next_positions.each do |next_position|
      path_score = score_path(current_path + [next_position])
      if !@lowest_score[next_position] || (path_score <= @lowest_score[next_position] || path_score == @lowest_score[next_position] + 1000)
        @lowest_score[next_position] ||= path_score
        next_path << current_path + [next_position]
      end
    end
  end

  return all_paths
end

puts "Part 1 A* is a bit slow, but oh that part two is so sweet...."
path, correct = a_star([@reindeer[0], @reindeer[1]])
puts correct

all_paths = all_shortest_paths(correct).select{|path| score_path(path) == correct}

all_paths.each do |path|
  path.each do |point|
    @g.grid[point[0]][point[1]] = "O"
  end
end

# @g.print_grid(clear: false)  # Uncomment to see the paths
puts @g.count("O")
