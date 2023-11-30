load "../../grid.rb"

lines = IO.readlines("input").map{|l| l.chomp.split('').map(&:to_i)}

def flash_grid grid, flashes, x, y
  grid[x][y] = 0
  if x < 9
    unless flashes.include?([x+1,y])
      puts "updating #{x+1}, #{y} because of #{x}, #{y}"
      if x+1 == 1 && y == 9
        # sleep 20
      end
      grid[x+1][y] += 1
    end
  end
  if x > 0
    unless flashes.include?([x-1,y])
      puts "updating #{x-1}, #{y} because of #{x}, #{y}"
      if x-1 == 1 && y == 9
        # sleep 20
      end
      grid[x-1][y] += 1
    end
  end
  if x < 9 && y < 9
    unless flashes.include?([x+1,y+1])
      puts "updating #{x+1}, #{y+1} because of #{x}, #{y}"
      if x+1 == 1 && y+1 == 9
        # sleep 20
      end
      grid[x+1][y+1] += 1
    end
  end
  if x > 0 && y > 0
    unless flashes.include?([x-1,y-1])
      puts "updating #{x-1}, #{y-1} because of #{x}, #{y}"
      if x-1 == 1 && y-1 == 9
        # sleep 20
      end
      grid[x-1][y-1] += 1
    end
  end
  if x < 9 && y > 0
    unless flashes.include?([x+1,y-1])
      puts "updating #{x+1}, #{y-1} because of #{x}, #{y}"
      if x+1 == 1 && y-1 == 9
        # sleep 20
      end
      grid[x+1][y-1] += 1
    end
  end
  if x > 0 && y < 9
    unless flashes.include?([x-1,y+1])
      puts "updating #{x-1}, #{y+1} because of #{x}, #{y}"
      if x-1 == 1 && y+1 == 9
        # sleep 20
      end
      grid[x-1][y+1] += 1
    end
  end
  if y < 9
    unless flashes.include?([x,y+1])
      puts "updating #{x}, #{y+1} because of #{x}, #{y}"
      if x == 1 && y+1 == 9
        # sleep 20
      end
      grid[x][y+1] += 1
    end
  end
  if y > 0
    unless flashes.include?([x,y-1])
      puts "updating #{x}, #{y-1} because of #{x}, #{y}"
      if x == 1 && y-1 == 9
        # sleep 20
      end
      grid[x][y-1] += 1
    end
  end
  grid 
end


mx = lines.length
my = lines[0].length

puts mx
puts my

grid = new_grid mx, my, 0

grid = lines

steps = 0
flashes = 0



while true
  flashed = []
  steps += 1
  print_grid grid,','
  puts "Step #{(steps)}"

  0.upto(mx-1) do |x|
    0.upto(my-1) do |y|
      grid[x][y] += 1
      # print_grid grid,','
      # if grid[x][y] > 9
      #   flashes += 1
      #   grid = flash_grid grid, flashed, x, y
      #   print_grid grid,','
      #   flashed << [x,y]
      # end
    end
  end
  print_grid grid,','
  puts "Step #{(steps)}"

  while grid.any?{|l| l.any?{|c| c > 9}}
    
    0.upto(mx-1) do |x|
      0.upto(my-1) do |y|
        if grid[x][y] > 9
          flashes += 1
          flash_grid grid, flashed, x, y
          flashed << [x,y]
          print_grid grid,','
          puts "Step #{(steps)}"
        end
      end
    end
  end
  (puts steps; return) if grid.sum{|l| l.sum} == 0
  print_grid grid,','
  puts "Step #{(steps)}"
end

puts flashes

# 1702 wrong
# 1722 too low