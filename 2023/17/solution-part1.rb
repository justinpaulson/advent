require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
@grid = new_grid lines.length, lines[0].length
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    @grid[y][x] = char.to_i
  end
end

cursor = [0, 0, :R]

dest = [@grid.length - 1, @grid[0].length - 1]

def lowest_score scores, points
  low = [0,0,:R, {D: 9999, DD: 9999, DDD: 9999, U: 9999, UU: 9999, UUU: 9999, L: 9999, LL: 9999, LLL: 9999, R: 9999, RR: 9999, RRR: 9999} ]
  lowest_score = 9999
  points.each do |(y,x,d)|
    if scores[y][x][d] < lowest_score
      low = [y,x,d,scores[y][x]]
      lowest_score = scores[y][x][d]
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

def a_star start, goal, h
  set = [start]
  from = {}
  g = new_grid @grid.length, @grid[0].length
  0.upto(g.length-1) do |y|
    0.upto(g[0].length-1) do |x|
      g[y][x] = {D: 9999, DD: 9999, DDD: 9999, U: 9999, UU: 9999, UUU: 9999, L: 9999, LL: 9999, LLL: 9999, R: 9999, RR: 9999, RRR: 9999}
    end
  end
  g[start[0]][start[1]][:D] = 0
  g[start[0]][start[1]][:U] = 0
  g[start[0]][start[1]][:L] = 0
  g[start[0]][start[1]][:R] = 0

  f = new_grid @grid.length, @grid[0].length

  0.upto(f.length-1) do |y|
    0.upto(f[0].length-1) do |x|
      f[y][x] = {D: 9999, DD: 9999, DDD: 9999, U: 9999, UU: 9999, UUU: 9999, L: 9999, LL: 9999, LLL: 9999, R: 9999, RR: 9999, RRR: 9999}
    end
  end

  f[start[0]][start[1]][:D] = h[start[0]][start[1]]
  f[start[0]][start[1]][:U] = h[start[0]][start[1]]
  f[start[0]][start[1]][:L] = h[start[0]][start[1]]
  f[start[0]][start[1]][:R] = h[start[0]][start[1]]

  while set.length > 0
    curr_y, curr_x, curr_dir, lowest = lowest_score f, set

    return [reconstruct_path(from,[curr_y, curr_x]), g[curr_y][curr_x][curr_dir]] if curr_y == goal[0] && curr_x == goal[1]

    set -= [[curr_y, curr_x, curr_dir]]

    last = from[[curr_y, curr_x, curr_dir]]
    next_last = nil
    third_last = nil
    next_last = from[[last[0],last[1],last[2]]] if last
    third_last = from[[next_last[0],next_last[1],next_last[2]]] if next_last

    neighbors = []
    if !last || !next_last || !third_last || (
        !(last[0] == next_last[0] && next_last[0] == third_last[0] && last[0] == curr_y)
      )
      neighbors << [curr_y, curr_x-1] if curr_x > 0
      neighbors << [curr_y, curr_x+1] if curr_x < @grid[0].length - 1
    end

    if !last || !next_last || !third_last || (
        !(last[1] == next_last[1] && next_last[1] == third_last[1] && last[1] == curr_x)
      )
      neighbors << [curr_y-1, curr_x] if curr_y > 0
      neighbors << [curr_y+1, curr_x] if curr_y < @grid.length - 1
    end


    neighbors.delete([last[0],last[1]]) if last

    neighbors.each do |(y, x)|
      dir = :L
      dir = :R if curr_x < x
      dir = :D if curr_y < y
      dir = :U if curr_y > y
      case dir
      when :L
        if curr_dir == :L
          dir = :LL
        elsif curr_dir == :LL
          dir = :LLL
        end
      when :R
        if curr_dir == :R
          dir = :RR
        elsif curr_dir == :RR
          dir = :RRR
        end
      when :U
        if curr_dir == :U
          dir = :UU
        elsif curr_dir == :UU
          dir = :UUU
        end
      when :D
        if curr_dir == :D
          dir = :DD
        elsif curr_dir == :DD
          dir = :DDD
        end
      end

      tent_g = g[curr_y][curr_x][curr_dir] + @grid[y][x]
      if tent_g <= g[y][x][dir]
        from[[y,x,dir]] = [curr_y, curr_x, curr_dir]
        g[y][x][dir] = tent_g
        f[y][x][dir] = tent_g + h[y][x]
        set << [y,x,dir] if !set.include?([y,x,dir])
      end
    end

    # print_grid g.map{|row| row.map{|scores| scores.select{|k,v| (v || 9999) < 9999}}}, ",", [curr_y, curr_x]
    # puts "From: #{from.to_s}"
    # puts "Neighbors: #{neighbors.to_s}"
    # puts "Set: #{set.to_s}"
    # puts "F:"
    # # print_grid f.map{|row| row.map{|scores| scores.select{|k,v| (v || 9999) < 9999}}}, ",", nil, false
    # puts "curr: #{curr_y}, #{curr_x}, #{curr_dir}, #{lowest}"
    # puts "Score: #{g[curr_y][curr_x][curr_dir]}"
    # puts "Last: #{last}"
    # puts "Next Last: #{next_last}"
    # puts "Third Last: #{third_last}"
    # key_wait
    # sleep 0.1
  end

  return false
end

h = new_grid @grid.length, @grid[0].length, 0

0.upto(h.length-1) do |y|
  0.upto(h[0].length-1) do |x|
    h[y][x] = h.length - 1 - y + h[0].length - 1 - x
  end
end

puts a_star(cursor, dest, h).last

# wrong
# 1056

# too high
# 1273
# 1299
