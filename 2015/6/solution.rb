load "../../grid.rb"

lines = File.readlines("input")

def turn_on grid, x1, y1, x2, y2
  x1.upto(x2) do |x|
    y1.upto(y2) do |y|
      grid[x][y] += 1
    end
  end
  grid
end

def turn_off grid, x1, y1, x2, y2
  x1.upto(x2) do |x|
    y1.upto(y2) do |y|
      grid[x][y] -= 1
      grid[x][y] = 0 if grid[x][y] < 0
    end
  end
  grid
end

def toggle cell
  cell == "." ? "#" : "."
end

def toggle_rect grid, x1, y1, x2, y2
  x1.upto(x2) do |x|
    y1.upto(y2) do |y|
      grid[x][y] += 2 # toggle grid[x][y]
    end
  end
  grid
end

grid = []
0.upto(999) do |_|
  grid << []
end

0.upto(999) do |b|
  0.upto(999) do |_|
    grid[b] << 0
  end
end

print_grid grid

lines.each do |line|
  line_parts = line.split(" ")
  case line_parts[0]
  when "turn"
    first_full, last_full = line.split(" through ")
    x1, y1 = first_full.split(" ").last.split(",").map(&:to_i)
    x2, y2 = last_full.split(",").map(&:to_i)
    send(line_parts[0..1].join("_").to_sym, grid, x1, y1, x2, y2)
  when "toggle"
    first_full, last_full = line.split(" through ")
    x1, y1 = first_full.split(" ").last.split(",").map(&:to_i)
    x2, y2 = last_full.split(",").map(&:to_i)
    toggle_rect grid, x1, y1, x2, y2
  end
end

ans=grid.flatten.sum

puts ans