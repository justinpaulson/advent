require "../../grid.rb"

ARGV[0] ||= "input"

lines = IO.readlines(ARGV[0])

temp_grids = []

def find_symmetry grid, old_sym = []
  reflection = []
  puts "testing grid:"
  print_grid grid
  0.upto(grid.length-2) do |y|
    top = grid[0..y].reverse
    bottom = grid[y+1..-1]

    i = 0
    # puts "top: "
    # print_grid top
    check_top = top[i]

    # puts "bottom: "
    # print_grid bottom
    check_bottom = bottom[i]

    while check_top == check_bottom && i <= check_bottom.length - 1 && i <= check_top.length - 1
      i += 1
      check_top = top[i]
      check_bottom = bottom[i]
      # puts "Checking: #{check_top} == #{check_bottom}"
    end
    if i >= bottom.length || i >= top.length
      # puts "Found reflection #{y+1}"
      return [false, y + 1] unless old_sym == [false, y + 1]
    end
  end

  # rotate the grid 90 degrees counter clockwise
  grid = grid.transpose

  # puts "Rotated grid: "

  # print_grid grid

  0.upto(grid.length-2) do |y|
    top = grid[0..y].reverse
    bottom = grid[y+1..-1]

    i = 0
    check_top = top[i]
    check_bottom = bottom[i]
    while check_top == check_bottom && i < check_bottom.length - 1 && i < check_top.length - 1
      i += 1
      check_top = top[i]
      check_bottom = bottom[i]
    end
    if i >= bottom.length || i >= top.length
      # puts "Found reflection #{y+1}"
      return [true, y + 1] unless old_sym == [true, y + 1]
    end
  end

  return reflection
end

i = 0
lines.each do |line|
  temp_grids[i] ||= []
  if line.chomp == ""
    i += 1
  else
    temp_grids[i] << line.chomp
  end
end

grids = []

temp_grids.each do |text_grid|
  grids << new_grid(text_grid.length, text_grid[0].length)
  text_grid.each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      grids[-1][y][x] = char
    end
  end
end


# total = 0
# grids.each do |grid|
#   sym = find_symmetry(grid)
#   print_grid grid
#   total += sym[0] ? sym[1] : sym[1] * 100
# end


# puts total

total = 0
grids = grids.map do |grid|
  old_sym = find_symmetry(grid)
  found_sym = false
  0.upto(grid.length-1) do |y|
    next if found_sym
    0.upto(grid[y].length-1) do |x|
      next if found_sym
      new_grid = Marshal.load(Marshal.dump(grid))
      new_grid[y][x] = grid[y][x] == "#" ? "." : "#"
      sym = find_symmetry(new_grid, old_sym)
      if !sym.empty? && sym != old_sym
        puts "Original Grid:"
        print_grid grid
        puts "Old Sym: #{old_sym}"
        puts "Testing Grid: "
        print_grid new_grid
        puts "Old Sym: #{old_sym}"
        puts "Found a reflection!"
        puts "Symmetry: #{sym}"
        puts "y: #{y}, x: #{x}"
        # sleep 1
        total += sym[0] ? sym[1] : sym[1] * 100
        found_sym = true
      end
    end
  end
end


puts total

puts grids.count


#too low
# 21065
# 35115
