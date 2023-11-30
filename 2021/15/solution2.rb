load "../../grid.rb"

# grid = new_grid lines.length, lines[0].length, 0
@grid = IO.readlines("test").map{|l| l.chomp.split('').map(&:to_i)}

h = new_grid @grid.length, @grid[0].length, 0

0.upto(h.length-1) do |y|
  0.upto(h[0].length-1) do |x|
    h[y][x] = h.length - 1 - y + h[0].length - 1 - x
  end
end

paths = []

start = [0, 0]
finish = [@grid.length-1, @grid[0].length-1]


@all_paths = []

def lowest_score scores, points
  low = [0,0,9999999999]
  points.each do |y,x|
    low = [y,x,scores[y][x]] if scores[y][x] < low[2]
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
  g = new_grid @grid.length, @grid[0].length, 99999999
  g[start[0]][start[1]] = 0

  f = new_grid @grid.length, @grid[0].length, 99999999
  f[start[0]][start[1]] = h[start[0]][start[1]]

  while set.length > 0
    curr_y, curr_x, curr_low = lowest_score f, set
    return [reconstruct_path(from,[curr_y, curr_x]), g[curr_y][curr_x]] if curr_y == goal[0] && curr_x == goal[1]
    
    set -= [[curr_y, curr_x]]

    neighbors = []
    neighbors << [curr_y+1, curr_x] if curr_y < @grid.length - 1
    neighbors << [curr_y, curr_x+1] if curr_x < @grid[0].length - 1
    neighbors << [curr_y-1, curr_x] if curr_y > 0
    neighbors << [curr_y, curr_x-1] if curr_x > 0

    neighbors.each do |y, x|
      tent_g = g[curr_y][curr_x] + @grid[y][x]
      if tent_g < g[y][x]
        from[[y,x]] = [curr_y, curr_x]
        g[y][x] = tent_g
        f[y][x] = tent_g + h[y][x]
        set << [y,x] if !set.include?([y,x])
      end
    end

    print_grid g, ","
    sleep 0.01
  end

  return false
end

# p a_star(start, finish, h).last

def bump num, multi
  return num if multi == 0
  1.upto(multi) do |i|
    num += 1
    num = 1 if num == 10
  end
  num
end


@big_grid = new_grid @grid.length*5, @grid[0].length*5, 0

0.upto(@big_grid.length-1) do |y|
  multi_y = y / @grid.length
  0.upto(@big_grid[0].length-1) do |x|
    multi = multi_y + x / @grid[0].length
    @big_grid[y][x] = bump @grid[y % @grid.length][x % @grid[0].length], multi
  end
end

@grid = @big_grid

finish = [@grid.length-1, @grid[0].length-1]

h = new_grid @grid.length, @grid[0].length, 0

0.upto(h.length-1) do |y|
  0.upto(h[0].length-1) do |x|
    h[y][x] = h.length - 1 - y + h[0].length - 1 - x
  end
end

p a_star(start, finish, h).last