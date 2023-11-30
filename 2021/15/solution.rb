load "../../grid.rb"

# grid = new_grid lines.length, lines[0].length, 0
grid = IO.readlines("test").map{|l| l.chomp.split('').map(&:to_i)}

print_grid grid

paths = []

start = [0, 0]
finish = [grid.length, grid[0].length]


@all_paths = []

def get_min_path grid, min_path, path, current_total, finish
  # puts path.to_s
  # puts current_total
  return current_total if current_total > min_path
  return current_total if path.length > (grid.length * 2 + grid.length/4)
  if path.include? finish
    puts "we found a path!"
    # puts path.to_s
    puts current_total
    @all_paths << path
    puts @all_paths.count
    return [min_path, current_total].min
  end

  current_point = [path.last[0], path.last[1]]

  # puts "Checking point: #{current_point.to_s}"
  # puts "Total: #{current_total}"
  # puts "Path: #{path.to_s}"
  # puts "Path length: #{path.length}"

  next_paths = []

  next_paths << [current_point[0]-1,current_point[1]] if current_point[0] > 0 && !path.include?([current_point[0]-1,current_point[1]])
  next_paths << [current_point[0],current_point[1]-1] if current_point[1] > 0 && !path.include?([current_point[0],current_point[1]-1])
  next_paths << [current_point[0]+1,current_point[1]] if current_point[0] < grid.length - 1 && !path.include?([current_point[0]+1,current_point[1]])
  next_paths << [current_point[0],current_point[1]+1] if current_point[1] < grid[0].length - 1 && !path.include?([current_point[0],current_point[1]+1])

  return min_path if next_paths.length == 0

  return next_paths.map{|np| get_min_path(grid, min_path, path + [[np[0],np[1]]], current_total + grid[np[0]][np[1]],  finish)}.min
end

min_path = grid[0].sum + grid.sum{|l| l.last}
# puts grid[0].sum
# puts min_path


# p get_min_path grid, min_path, [start], grid[0][0], finish


def unvisited_min(grid, visited, cursor)
  points = []
  puts cursor.to_s
  points << [cursor[0]+1, cursor[1]] if cursor[0] < grid.length - 1 && !visited.include?([cursor[0]+1, cursor[1]])
  points << [cursor[0], cursor[1]+1] if cursor[1] < grid[0].length - 1 && !visited.include?([cursor[0], cursor[1]+1])
  points << [cursor[0]-1, cursor[1]] if cursor[0] > 0 && !visited.include?([cursor[0]-1, cursor[1]])
  points << [cursor[0], cursor[1]-1] if cursor[1] > 0 && !visited.include?([cursor[0], cursor[1]-1])
  min_point = []
  min = 10
  points.each{|y, x| (min = grid[y][x]; min_point = [y,x]) if grid[y][x] < min}
  return [min, min_point]
end

y = 0
x = 0

min_grid = new_grid grid.length, grid[0].length, 9999999999

visited = []
dist = 0

min_grid[0][0] = 0

finish = [grid.length-1, grid[0].length-1]

while !visited.include?(finish)
  visited << [y,x]
  current_min = min_grid[y][x]
  winner = 99999999999
  winning_y = 99999
  winning_x = 99999
  if y < grid.length - 1 && !visited.include?([y+1, x])
    puts y 
    puts x
    min_grid[y+1][x] = [min_grid[y+1][x], current_min + grid[y+1][x]].min
    if min_grid[y+1][x] < winner
      winner = min_grid[y+1][x]
      winning_y = y+1
      winning_x = x
    end
  end
  if y > 0 && !visited.include?([y-1, x])
    min_grid[y-1][x] =  current_min + grid[y-1][x]
    if min_grid[y-1][x] < winner
      winner = min_grid[y-1][x]
      winning_y = y-1
      winning_x = x
    end
  end
  if x < grid[0].length - 1 && !visited.include?([y, x+1])
    min_grid[y][x+1] = [min_grid[y][x+1], current_min + grid[y][x+1]].min
    if min_grid[y][x+1] < winner
      winner = min_grid[y][x+1]
      winning_y = y 
      winning_x = x+1
    end
  end
  if x > 0 && !visited.include?([y, x-1])
    puts "why tho?"
    min_grid[y][x-1] = [min_grid[y][x-1] , current_min + grid[y][x-1]].min
    if min_grid[y][x-1] < winner
      winner = min_grid[y][x-1]
      winning_y = y 
      winning_x = x-1
    end
  end
  print_grid min_grid, ","
  sleep 1

  y = winning_y
  x = winning_x
end

print_grid min_grid, ","

p min_grid[finish[0]][finish[1]]
