require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
@grid = new_grid lines.length, lines[0].length
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    @grid[y][x] = char.to_i
  end
end

cursor = [0, 0, :O]

dest = [@grid.length - 1, @grid[0].length - 1]

def lowest_score scores, points
  low = [0,0,:R, {D4: 9999, D5: 9999, D6: 9999, D7: 9999, D8: 9999, D9: 9999, D10: 9999, U4: 9999, U5: 9999, U6: 9999, U7: 9999, U8: 9999, U9: 9999, U10: 9999, L4: 9999, L5: 9999, L6: 9999, L7: 9999, L8: 9999, L9: 9999, L10: 9999, R4: 9999, R5: 9999, R6: 9999, R7: 9999, R8: 9999, R9: 9999, R10: 9999} ]
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
      g[y][x] = {D4: 9999, D5: 9999, D6: 9999, D7: 9999, D8: 9999, D9: 9999, D10: 9999, U4: 9999, U5: 9999, U6: 9999, U7: 9999, U8: 9999, U9: 9999, U10: 9999, L4: 9999, L5: 9999, L6: 9999, L7: 9999, L8: 9999, L9: 9999, L10: 9999, R4: 9999, R5: 9999, R6: 9999, R7: 9999, R8: 9999, R9: 9999, R10: 9999}
    end
  end
  # g[start[0]][start[1]][:D4] = 9999
  # g[start[0]][start[1]][:U4] = 0
  # g[start[0]][start[1]][:L4] = 0
  # g[start[0]][start[1]][:R4] = 9999
  g[start[0]][start[1]][:O] = 0

  f = new_grid @grid.length, @grid[0].length

  0.upto(f.length-1) do |y|
    0.upto(f[0].length-1) do |x|
      f[y][x] = {D4: 9999, D5: 9999, D6: 9999, D7: 9999, D8: 9999, D9: 9999, D10: 9999, U4: 9999, U5: 9999, U6: 9999, U7: 9999, U8: 9999, U9: 9999, U10: 9999, L4: 9999, L5: 9999, L6: 9999, L7: 9999, L8: 9999, L9: 9999, L10: 9999, R4: 9999, R5: 9999, R6: 9999, R7: 9999, R8: 9999, R9: 9999, R10: 9999}
    end
  end

  # f[start[0]][start[1]][:D4] = h[start[0]][start[1]]
  # f[start[0]][start[1]][:U4] = h[start[0]][start[1]]
  # f[start[0]][start[1]][:L4] = h[start[0]][start[1]]
  # f[start[0]][start[1]][:R4] = h[start[0]][start[1]]
  f[start[0]][start[1]][:O] = h[start[0]][start[1]]

  max_score = 0

  while set.length > 0
    curr_y, curr_x, curr_dir, lowest = lowest_score f, set

    return [reconstruct_path(from,[curr_y, curr_x, curr_dir]), g[curr_y][curr_x][curr_dir]] if curr_y == goal[0] && curr_x == goal[1]

    set -= [[curr_y, curr_x, curr_dir]]

    last = from[[curr_y, curr_x, curr_dir]]

    neighbors = []

    if curr_dir == :O
      4.upto(10) do |i|
        neighbors << [curr_y + i, curr_x] if curr_y + i <= @grid.length - 1
        neighbors << [curr_y, curr_x + i] if curr_x + i <= @grid[0].length - 1
      end
    end

    if curr_dir.to_s.include?("D") || curr_dir.to_s.include?("U")
      neighbors << [curr_y, curr_x-4] if curr_x - 4 >= 0
      neighbors << [curr_y, curr_x+4] if curr_x + 4 <= @grid[0].length - 1

      if curr_dir.to_s.include?("D")
        1.upto(10 - curr_dir.to_s[1..-1].to_i) do |i|
          neighbors << [curr_y + i, curr_x] if curr_y + i <= @grid.length - 1
        end
      else
        1.upto(10 - curr_dir.to_s[1..-1].to_i) do |i|
          neighbors << [curr_y - i, curr_x] if curr_y - i >= 0
        end
      end
    end

    if curr_dir.to_s.include?("L") || curr_dir.to_s.include?("R")
      neighbors << [curr_y-4, curr_x] if curr_y - 4 >= 0
      neighbors << [curr_y+4, curr_x] if curr_y + 4 <= @grid.length - 1

      if curr_dir.to_s.include?("L")
        1.upto(10 - curr_dir.to_s[1..-1].to_i) do |i|
          neighbors << [curr_y, curr_x-i] if curr_x - i >= 0
        end
      else
        1.upto(10 - curr_dir.to_s[1..-1].to_i) do |i|
          neighbors << [curr_y, curr_x+i] if curr_x + i <= @grid[0].length - 1
        end
      end
    end

    neighbors.delete([last[0],last[1]]) if last

    # puts "Neighbords: #{neighbors.to_s}"

    neighbors.each do |(y, x)|
      dir = :L4
      dir = :R4 if curr_x < x
      dir = :D4 if curr_y < y
      dir = :U4 if curr_y > y
      case dir
      when :L4
        if curr_dir.to_s.include?("L") || curr_dir == :O
          dir = ("L" + (curr_x - x + curr_dir.to_s[1..-1].to_i).to_s ).to_sym
        end
      when :R4
        if curr_dir.to_s.include?("R") || curr_dir == :O
          dir = ("R" + (x - curr_x + curr_dir.to_s[1..-1].to_i).to_s ).to_sym
        end
      when :U4
        if curr_dir.to_s.include?("U") || curr_dir == :O
          dir = ("U" + (curr_y - y + curr_dir.to_s[1..-1].to_i).to_s ).to_sym
        end
      when :D4
        if curr_dir.to_s.include?("D") || curr_dir == :O
          dir = ("D" + (y - curr_y + curr_dir.to_s[1..-1].to_i).to_s ).to_sym
        end
      end

      # puts "curr: #{curr_y}, #{curr_x}, #{curr_dir}, #{lowest}"
      # puts "next: #{y}, #{x}, #{dir}"
      # puts @grid[y][x]
      # puts g[curr_y][curr_x][curr_dir]
      tent_g = g[curr_y][curr_x][curr_dir]

      unless curr_y == y
        y.downto(curr_y + 1).each do |i|
          tent_g += @grid[i][x]
        end

        (curr_y - 1).downto(y).each do |i|
          tent_g += @grid[i][x]
        end
      else
        x.downto(curr_x + 1).each do |i|
          tent_g += @grid[y][i]
        end

        (curr_x - 1).downto(x).each do |i|
          tent_g += @grid[y][i]
        end
      end

      # puts tent_g

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
    if g[curr_y][curr_x][curr_dir] > max_score
      max_score = g[curr_y][curr_x][curr_dir]
      puts "Max: #{max_score}"
    end
    # puts "Score: #{g[curr_y][curr_x][curr_dir]}"
    # puts "Last: #{last}"
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

path = a_star(cursor, dest, h)
puts path.to_s
puts path.last

# wrong
# 1056

# too high
# 1273
# 1299
