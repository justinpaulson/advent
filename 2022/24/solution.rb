require '../../grid'

def print_blizzards blizzards
  grid = new_grid 5, 7, "."
  blizzards.each{|(y,x)| grid[y][x] = "#"}
  print_grid grid, "", false
  puts blizzards.to_s
end

def move_blizzard bl
  y,x,dir = bl
  
  # real use 150, 20, 151, 21
  # test use 6, 4, 7, 5

  case dir # ^v><
  when "<"
    x = x - 1
    x = 150 if x == 0
  when "^"
    y = y - 1
    y = 20 if y == 0
  when ">"
    x = x + 1
    x = 1 if x == 151
  when "v"
    y = y + 1
    y = 1 if y == 21
  end
  
  [y,x,dir]
end

def available_paths blizzards, current
  paths = [
    [current[0], current[1]+1],
    [current[0]+1, current[1]],
    [current[0]-1, current[1]],
    [current[0], current[1]-1]
  ]

  # real use 21, 151
  # test use 5, 7

  # real goal 21, 150
  # test goal 5, 6

  paths = paths.select{|(y,x)| (y > 0 && y < 21 && x > 0 && x < 151) || (y==21 && x==150) }

  paths = paths.select{|p| !blizzards.include?(p)}

  paths = blizzards.include?(current) ? paths : paths + [current]

  paths
end

def in_blizzard blizzards, current
  blizzards.map{|(y,x,_)| [y,x]}.include?(current)
end

def best_case current, goal
  goal[0]-current[0] + goal[1]-current[1]
end

@min_solution = 325
@solves = 0
def shortest_path blizzards, current, goal, moves, path
  # if in_blizzard blizzards, current
  #   puts "This path hits blizzard!"
  #   return @min_solution + 1
  # end
  puts current.to_s, moves if current[1] > 60

  puts @solves if @solves % 1000000 == 0
  if (moves + best_case(current, goal)) > @min_solution
    @solves += 1
    return @min_solution+1 
  end

  if current == goal
    if @min_solution > moves
      puts moves
      puts path.to_s
      @min_solution = moves
    end
    return moves
  end

  blizzards = blizzards.map{|b| move_blizzard b }
  
  blizzards_positions = blizzards.map{|(y,x,_)| [y,x]}
  
  paths = available_paths(blizzards_positions, current)
  
  # print_blizzards blizzards_positions
  # puts current.to_s
  # puts paths.to_s
  
  if paths.length == 0
    @solves += 1
    return @min_solution + 5 
  end
  

  return paths.map{|n| shortest_path(blizzards, n, goal, moves+1, path + [current])}.min
end

lines = IO.readlines("input").map(&:chomp)

blizzards = []

lines.each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    if c == "v" || c == ">" || c == "<" || c == "^"
      blizzards << [y,x,c]
    end
  end
end

current = [0,1]
moves = 0
goal = [21, 150]
# goal = [5, 6]

puts shortest_path blizzards, current, goal, moves, []

puts @min_solution

# 876 too high
# 425 too high 

# 325 wrong
# 375 wrong