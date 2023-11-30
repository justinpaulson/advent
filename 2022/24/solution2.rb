load "../../grid.rb"

def move_blizzard bl
  y,x,dir = bl

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

def available_paths blizzards, current, goal
  paths = [
    [current[0], current[1]+1],
    [current[0]+1, current[1]],
    [current[0]-1, current[1]],
    [current[0], current[1]-1]
  ]

  paths = paths.select{|(y,x)| (y > 0 && y < 21 && x > 0 && x < 151) || (y==goal[0] && x==goal[1]) }

  paths = paths.select{|p| !blizzards.include?(p)}

  paths = blizzards.include?(current) ? paths : paths + [current]

  paths
end

def blizz_pos blizzards
  blizzards.map{|(y,x,_)| [y,x]}
end

lines = IO.readlines("input").map(&:chomp)

@blizzards = [[]]

lines.each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    if c == "v" || c == ">" || c == "<" || c == "^"
      @blizzards[0] << [y,x,c]
    end
  end
end

1.upto(2000) do |t|
  @blizzards << @blizzards[t-1].map{|b| move_blizzard b}
end

h = new_grid 22, 151, 0

0.upto(h.length-1) do |y|
  0.upto(h[0].length-1) do |x|
    h[y][x] = 21 - y + 150 - x
  end
end

h2 = new_grid 22, 151, 0

0.upto(h2.length-1) do |y|
  0.upto(h2[0].length-1) do |x|
    h2[y][x] = y + (x -1) 
  end
end


paths = []

start = [0, 0, 1]
finish = [21, 150]

@all_paths = []

def lowest_score scores, points
  low = [0, 0, 1, 9999]
  points.each do |t,y,x|
    low = [t,y,x,scores[t][y][x]] if scores[t][y][x] < low[3]
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

def a_star start, goal, h
  set = [start]
  from = {}
  g = 
  g = Array.new(2000){ new_grid 22, 151, 9999 }
  g[start[0]][start[1]][start[2]] = 0

  f = Array.new(2000){ new_grid 22, 151, 9999 }
  f[start[0]][start[1]][start[2]] = h[start[1]][start[2]]

  while set.length > 0
    curr_t, curr_y, curr_x, curr_low = lowest_score f, set
    # puts curr_t, curr_y, curr_x, curr_low
    # puts [curr_t, curr_y, curr_x].to_s
    return [reconstruct_path(from,[curr_t, curr_y, curr_x]), g[curr_t][curr_y][curr_x]] if curr_y == goal[0] && curr_x == goal[1]
    
    set -= [[curr_t, curr_y, curr_x]]

    moves = available_paths(blizz_pos(@blizzards[curr_t+1]), [curr_y, curr_x], goal)

    moves.each do |y, x|
      tent_g = g[curr_t][curr_y][curr_x] + 1
      # puts g[curr_t+1][y][x]
      # puts tent_g
      if tent_g < g[curr_t+1][y][x]
        from[[curr_t+1,y,x]] = [curr_t, curr_y, curr_x]
        g[curr_t+1][y][x] = tent_g
        f[curr_t+1][y][x] = tent_g + h[y][x]
        set << [curr_t+1,y,x] if !set.include?([curr_t+1,y,x])
      end
    end
    # puts set.to_s

    # print_grid g, ","
    # sleep 0.01
  end

  return false
end

part_1 = a_star(start, finish, h).last

p part_1

start_2 = [part_1, 21, 150]

part_2_first = a_star(start_2, [0,1], h2).last

p part_1 + part_2_first

start_3 = [part_1 + part_2_first, 0, 1]

part_2_last = a_star(start_3, finish, h).last

p part_1 + part_2_first + part_2_last