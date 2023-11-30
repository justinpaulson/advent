load "../../grid.rb"
points= IO.readlines("input").map{|l| l.chomp.split(",").map(&:to_i)}
folds= IO.readlines("directions").map{|d| d.chomp.split("fold along ")[1].split("=")}
folds = folds.map{|d| d[1] = d[1].to_i; d}

puts points.to_s
puts folds.to_s

def fold_grid grid, dir, point
  if dir == "x"
    n_grid = new_grid grid.length, point, "."
  else
    n_grid = new_grid point, grid[0].length, "."
  end

  0.upto(n_grid.length-1) do |y|
    0.upto(n_grid[0].length-1) do |x|
      n_grid[y][x] = grid[y][x]
    end
  end

  if dir == "x"
    0.upto(n_grid.length-1) do |y|
      (grid[0].length-1).downto(point+1) do |x|
        if grid[y][x] == "#"
          n_grid[y][2*point-x] = "#"
        end
      end
    end
  else
    (grid.length-1).downto(point+1) do |y|
      0.upto(n_grid[0].length-1) do |x|
        if grid[y][x] == "#"
          n_grid[2*point-y][x] = "#"
        end
      end
    end
  end
  n_grid
end


max_y = points.map{|p| p[1]}.max+1
max_x = points.map{|p| p[0]}.max+1

grid = new_grid max_y, max_x, "."

puts max_x
puts max_y

points.each do |x,y|
  grid[y][x] = "#"
end

grid = fold_grid grid, folds[0][0], folds[0][1]

puts grid.sum{|l| l.count("#")}

folds[1..-1].each do |f|
  grid = fold_grid grid, f[0], f[1]
  # print_grid grid
  # sleep 5
end

print_grid grid


