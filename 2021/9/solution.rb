load "../../grid.rb"
lines = IO.readlines("input")

def risk_level grid, x, y
  1 + grid[x][y]
end

max_x = lines.length
max_y = lines[0].chomp.length

grid = new_grid lines.length, lines[0].chomp.length, 0
nines = 0
lines.each_with_index do |l, x|
  l.chomp.chars.each_with_index do |c, y|
    grid[x][y] = c.to_i
    nines += 1 if grid[x][y] == 9
  end
end

low_points = []

low_points << [0,max_y-1]
low_points << [max_x-1,0]

1.upto(max_y-2) do |y|
  check = grid[0][y]
  low_points << [0, y] if check < grid[0][y+1] && check < grid[0][y-1] && check < grid[1][y]

  check = grid[max_x-1][y]
  low_points << [max_x-1, y] if check < grid[max_x-1][y+1] && check < grid[max_x-1][y-1] && check < grid[max_x-2][y]
end

1.upto(max_x-2) do |x|
  check = grid[x][0]
  low_points << [x, 0] if check < grid[x+1][0] && check < grid[x-1][0] && check < grid[x][1]

  check = grid[x][max_y-1]
  low_points << [x, max_y-1] if check < grid[x-1][max_y-1] && check < grid[x+1][max_y-1] && check < grid[x][max_y-2]
end

1.upto(max_x-2) do |x|
  1.upto(max_y-2) do |y|
    check = grid[x][y]
    next unless check < grid[x+1][y] && check < grid[x-1][y] && check < grid[x][y+1] && check < grid[x][y-1]
    low_points << [x,y]
  end
end


p low_points.sum{|x,y| risk_level(grid, x, y)}

def fill_node(low_point, grid, fill_grid, x, y)
  return if fill_grid[x][y] != nil
  return if grid[x][y] == 9
  fill_grid[x][y] = low_point
  fill_node(low_point, grid, fill_grid, x-1, y) if x > 0
  fill_node(low_point, grid, fill_grid, x, y-1) if y > 0
  fill_node(low_point, grid, fill_grid, x+1, y) if x < grid.length - 1
  fill_node(low_point, grid, fill_grid, x, y+1) if y < grid[0].length - 1
end


fill_grid = new_grid grid.length, grid[0].length, nil
low_points.each do |x, y|
  fill_node([x,y], grid, fill_grid, x, y)
end

basins = low_points.map do |lp|
  fill_grid.sum{|l| l.sum{|c| c == lp ? 1 : 0}}
end

p basins.sort.reverse[0..2].inject(&:*)
