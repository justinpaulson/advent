load "../../grid.rb"

grid = IO.readlines("input").map{|l| l.chomp.chars}

def print_grid_25 grid
  puts `clear`
  0.upto(grid.length-1) do |y|
    0.upto(grid[y].length-1) do |x|
      print "\e[31m" if grid[y][x] == ">"
      print "\e[34m" if grid[y][x] == "v"
      if grid[y][x] == ">" or grid[y][x] == "v"
        print "█"
      else
        print " "
      end
      print "\e[0m" if grid[y][x] == ">" or grid[y][x] == "v"
    end
    puts ""
  end
end

def move? grid, cum
  if grid[cum[0]][cum[1]] == "v"
    if cum[0] == grid.length-1
      if grid[0][cum[1]] == "."
        true
      else
        false
      end
    elsif grid[cum[0]+1][cum[1]] == "."
      true
    else
      false
    end
  elsif grid[cum[0]][cum[1]] == ">"
    if cum[1] == grid[0].length-1
      if grid[cum[0]][0] == "."
        true
      else
        false
      end
    elsif grid[cum[0]][cum[1]+1] == "."
      true 
    else
      false
    end
  else
    false
  end
end

n_grid = new_grid grid.length, grid[0].length, "."

0.upto(grid.length-1) do |y|
  0.upto(grid[0].length-1) do |x|
    if grid[y][x] == ">"
      if move?(grid, [y,x])
        n_grid[y][(x+1)%grid[0].length] = ">"
      else
        n_grid[y][x] = ">"
      end
    elsif grid[y][x] == "v"
      n_grid[y][x] = "v"
    end
  end
end
grid = n_grid
n_grid = new_grid grid.length, grid[0].length, "."
0.upto(grid.length-1) do |y|
  0.upto(grid[0].length-1) do |x|
    if grid[y][x] == "v"
      if move?(grid, [y,x])
        n_grid[(y+1)%grid.length][x] = "v"
      else
        n_grid[y][x] = "v"
      end
    elsif grid[y][x] == ">"
      n_grid[y][x] = ">"
    end
  end
end

total = 1
while n_grid != grid
  total += 1
  grid = n_grid
  n_grid = new_grid grid.length, grid[0].length, "."
  0.upto(grid.length-1) do |y|
    0.upto(grid[0].length-1) do |x|
      if grid[y][x] == ">"
        if move?(grid, [y,x])
          n_grid[y][(x+1)%grid[0].length] = ">"
        else
          n_grid[y][x] = ">"
        end
      elsif grid[y][x] == "v"
        n_grid[y][x] = "v"
      end
    end
  end
  test_grid = n_grid
  n_grid = new_grid grid.length, grid[0].length, "."
  0.upto(grid.length-1) do |y|
    0.upto(grid[0].length-1) do |x|
      if test_grid[y][x] == "v"
        if move?(test_grid, [y,x])
          n_grid[(y+1)%grid.length][x] = "v"
        else
          n_grid[y][x] = "v"
        end
      elsif test_grid[y][x] == ">"
        n_grid[y][x] = ">"
      end
    end
  end
  print_grid_25 n_grid
  puts total
  sleep 0.2
end

puts total