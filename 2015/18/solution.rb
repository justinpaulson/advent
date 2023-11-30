load "../../grid.rb"

grid = IO.readlines("input").map{|l| l.chomp.chars}

print_grid grid

def count_neighbors grid, y, x
  t = 0
  t += 1 if x < 99 && grid[y][x+1] == "#"
  t += 1 if x > 0 && grid[y][x-1] == "#"
  t += 1 if y < 99 && x < 99 && grid[y+1][x+1] == "#"
  t += 1 if y > 0 && x < 99 && grid[y-1][x+1] == "#"
  t += 1 if y < 99 && grid[y+1][x] == "#"
  t += 1 if y > 0 && grid[y-1][x] == "#"
  t += 1 if y < 99 && x > 0 && grid[y+1][x-1] == "#"
  t += 1 if y > 0 && x > 0 && grid[y-1][x-1] == "#"
  t
end

def set_light grid, y, x
  val = grid[y][x]
  out = '.'
  neigh = count_neighbors grid, y, x
  if val == "#"
    out = "#" if neigh == 2 || neigh == 3
  else
    out = "#" if neigh == 3
  end
  out
end

steps = 100

grid[0][0] = '#'
grid[0][99] = '#'
grid[99][99] = '#'
grid[99][0] = '#'

while steps > 0
  steps -= 1
  n_grid = new_grid 100, 100, "."
  0.upto(99) do |y|
    0.upto(99) do |x|
      n_grid[y][x] = set_light grid, y, x
    end
  end
  grid = n_grid
  grid[0][0] = '#'
  grid[0][99] = '#'
  grid[99][99] = '#'
  grid[99][0] = '#'
end

p grid.sum{|l| l.count("#")}
