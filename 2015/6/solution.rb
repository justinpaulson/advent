load "../../grid.rb"
ARGV[0] ||= "input"
lines = File.readlines(ARGV[0]).map(&:chomp)

def turn_on1 grid, x1, y1, x2, y2
  x1.upto(x2) do |x|
    y1.upto(y2) do |y|
      grid[x][y] = 1
    end
  end
  grid
end

def turn_off1 grid, x1, y1, x2, y2
  x1.upto(x2) do |x|
    y1.upto(y2) do |y|
      grid[x][y] = 0
    end
  end
  grid
end

def turn_on2 grid, x1, y1, x2, y2
  x1.upto(x2) do |x|
    y1.upto(y2) do |y|
      grid[x][y] += 1
    end
  end
  grid
end

def turn_off2 grid, x1, y1, x2, y2
  x1.upto(x2) do |x|
    y1.upto(y2) do |y|
      grid[x][y] -= 1
      grid[x][y] = 0 if grid[x][y] < 0
    end
  end
  grid
end

def toggle grid, x1, y1, x2, y2
  x1.upto(x2) do |x|
    y1.upto(y2) do |y|
      grid[x][y] = grid[x][y] == 0 ? 1 : 0
    end
  end
end

def toggle_rect grid, x1, y1, x2, y2
  x1.upto(x2) do |x|
    y1.upto(y2) do |y|
      grid[x][y] += 2 # toggle grid[x][y]
    end
  end
  grid
end

g1 = Grid.new(1000,1000, 0)
g2 = Grid.new(1000,1000, 0)

lines.each do |line|
  line_parts = line.split(" ")
  case line_parts[0]
  when "turn"
    first_full, last_full = line.split(" through ")
    x1, y1 = first_full.split(" ").last.split(",").map(&:to_i)
    x2, y2 = last_full.split(",").map(&:to_i)
    send((line_parts[0..1].join("_")+"1").to_sym, g1.grid, x1, y1, x2, y2)
    send((line_parts[0..1].join("_")+"2").to_sym, g2.grid, x1, y1, x2, y2)
  when "toggle"
    first_full, last_full = line.split(" through ")
    x1, y1 = first_full.split(" ").last.split(",").map(&:to_i)
    x2, y2 = last_full.split(",").map(&:to_i)
    toggle g1.grid, x1, y1, x2, y2
    toggle_rect g2.grid, x1, y1, x2, y2
  end
end

puts g1.grid.flatten.count{|x| x > 0}

ans2 = g2.grid.flatten.sum
puts ans2
