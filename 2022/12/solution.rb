def print_grid grid, joiner=""
  puts `clear`
  0.upto(grid.length-1) do |y|
    print y.to_s
    print " "
    puts grid[y].map{|i| i == 99999 ? 0 : i}.join(joiner)
  end
  # sleep 0.25 
end

def new_grid y, x, fill="."
  Array.new(y) { Array.new(x) { fill } }
end

def can_move grid, current, n
  return false if n[0] < 0 || n[1] < 0 || n[0] > grid.length-1 || n[1] > grid[0].length-1
  grid[n[0]][n[1]].ord <= grid[current[0]][current[1]].ord + 1 
end

lines = IO.readlines("input")

elevs = new_grid lines.length, lines[0].chomp.length

s = [0,0]
e = [0,0]
aas = []
lines.each_with_index do |line, y|
  line.chomp.chars.each_with_index do |c, x|
    elevs[y][x] = c
    if c == "a" && x == 0
      aas << [y,x]
    end
    if c == "S"
      s = [y,x]
      elevs[y][x] = "a"
      aas << [y,x]
    end
    if c == "E"
      e = [y,x]
      elevs[y][x] = "z"
    end
  end
end

def find_all dist_grid, elevs, path
  # print_grid dist_grid, "." if Time.now.to_i % 50 == 0
  # puts path.to_s
  current = path[-1]
  new_dist = 1
  if path.length > 1
    prev = path[-2]
    # puts prev.to_s
    # puts dist_grid[prev[0]]
    # print_grid dist_grid
    new_dist += dist_grid[prev[0]][prev[1]]
  end
  if new_dist < dist_grid[current[0]][current[1]]
    dist_grid[current[0]][current[1]] = new_dist
  else
    return dist_grid #already been here in less time
  end
  if can_move(elevs, current, [current[0], current[1] + 1]) && [current[0], current[1] + 1] != path[-2] && new_dist < dist_grid[current[0]][current[1] + 1]
    dist_grid = find_all(dist_grid, elevs, path+[[current[0], current[1] + 1]])
  end

  if can_move(elevs, current, [current[0] + 1, current[1]]) && [current[0] + 1, current[1]] != path[-2] && new_dist < dist_grid[current[0] + 1][current[1]]
    dist_grid = find_all(dist_grid, elevs, path+[[current[0] + 1, current[1]]])
  end
  
  if can_move(elevs, current, [current[0], current[1] - 1]) && [current[0], current[1] - 1] != path[-2] && new_dist < dist_grid[current[0]][current[1] - 1]
    dist_grid = find_all(dist_grid, elevs, path+[[current[0], current[1] - 1]])
  end

  if can_move(elevs, current, [current[0] - 1, current[1]]) && [current[0] - 1, current[1]] != path[-2] && new_dist < dist_grid[current[0] - 1][current[1]]
    dist_grid = find_all(dist_grid, elevs, path+[[current[0] - 1, current[1]]])
  end
  dist_grid
end

current = s

path = [current]
grid = new_grid lines.length, lines[0].chomp.length, 99999
grid = find_all(grid, elevs, path)
puts grid[e[0]][e[1]] - 1

min_a = 99999
aas.each_with_index do |(y,x), i|
  path = [[y, x]]
  grid = new_grid lines.length, lines[0].chomp.length, 99999
  grid = find_all(grid, elevs, path)
  min_a = [grid[e[0]][e[1]] - 1, min_a].min
  puts "#{i+1} of #{aas.length}"
end

puts min_a

#444 is too high