lines = File.readlines("input")

def print_grid grid
  0.upto(grid.length-1) do |y|
    print y.to_s
    print " "
    puts grid[y].join
  end
end

def rect grid, width, height
  0.upto(height-1) do |y|
    0.upto(width-1) do |x|
      grid[y][x] = "#"
    end
  end
  grid
end

def rotate_row grid, row, amount
  amount = amount % 50
  puts "Rotating Row: #{row}, by #{amount}"
  grid[row] = grid[row].rotate(-amount)
  grid
end

def rotate_column grid, column, amount
  amount = amount % 6
  column_array = [grid[0][column], grid[1][column], grid[2][column], grid[3][column], grid[4][column], grid[5][column]]
  column_array = column_array.rotate(-amount)
  grid[0][column] = column_array[0]
  grid[1][column] = column_array[1]
  grid[2][column] = column_array[2]
  grid[3][column] = column_array[3]
  grid[4][column] = column_array[4]
  grid[5][column] = column_array[5]
  grid
end

grid = [["."]*50, ["."]*50, ["."]*50, ["."]*50, ["."]*50, ["."]*50]

print_grid grid
puts "------------------------------------------------------------"

lines.each do |line|
  ins = line.split(" ")
  case ins[0]
  when "rect"
    w, h = ins[1].split('x').map(&:to_i)
    puts "rect"
    puts "width: #{w}"
    puts "height: #{h}"
    grid = rect grid, w, h
  when "rotate"
    cr, amount = line.split("=")[1].split(" by ").map(&:to_i)
    puts "rotate"
    puts "#{ins[1]}: #{cr}"
    puts "amount: #{amount}"
    grid = send("rotate_#{ins[1]}".to_sym, grid, cr, amount)
  end
  print_grid grid
  puts "------------------------------------------------------------"
end

ans=grid.flatten.count("#")

puts ans