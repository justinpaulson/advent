require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
grid = new_grid lines.length, lines[0].length
start = []
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    grid[y][x] = char
    if char == "S"
      start = [y, x]
      grid[y][x] = "."
    end
  end
end

positions = {}

positions[start] = 1

# 1000.times do |i|
#   new_positions = {}
#   positions.each do |position, _|
#     y, x = position
#     # if y > grids_max_y
#     #   grids << deep_copy(original_grid)
#     if grid[(y+1) % grid.length][x % grid[0].length] == "."
#       new_positions[[y+1, x]] ||= 0
#       new_positions[[y+1, x]] += 1
#     end
#     if grid[(y-1) % grid.length][x % grid[0].length] == "."
#       new_positions[[y-1, x]] ||= 0
#       new_positions[[y-1, x]] += 1
#     end
#     if grid[y % grid.length][(x+1) % grid[0].length] == "."
#       new_positions[[y, x+1]] ||= 0
#       new_positions[[y, x+1]] += 1
#     end
#     if grid[y % grid.length][(x-1) % grid[0].length] == "."
#       new_positions[[y, x-1]] ||= 0
#       new_positions[[y, x-1]] += 1
#     end

#   end

#   positions = new_positions
# end

# puts positions.keys.count
# exit

# total_steps = 26501365
total_steps = 1000
clean_cycles = (total_steps - 129) / 131
overflow_cycles = total_steps - 129 - clean_cycles * 131

check_positions = [
  [0,4], [1,4], [1,3], [2,3], [2,2], [3,2], [3,1], [4,1],
  [4,0], [4,-1], [3,-1], [3,-2], [2,-2], [2,-3], [1,-3], [1,-4],
  [0,-4], [-1,-4], [-1,-3], [-2,-3], [-2,-2],[-3,-2],[-3,-1],[-4,-1],
  [-4,0], [-4,1], [-3,1], [-3,2], [-2,2], [-2,3], [-1,3], [-1,4]
]
(129 + 131 + 131 + 131 + overflow_cycles).times do |i|
  new_positions = {}
  positions.each do |position, _|
    y, x = position
    if grid[(y+1) % grid.length][x % grid[0].length] == "."
      new_positions[[y+1, x]] ||= 0
      new_positions[[y+1, x]] += 1
    end
    if grid[(y-1) % grid.length][x % grid[0].length] == "."
      new_positions[[y-1, x]] ||= 0
      new_positions[[y-1, x]] += 1
    end
    if grid[y % grid.length][(x+1) % grid[0].length] == "."
      new_positions[[y, x+1]] ||= 0
      new_positions[[y, x+1]] += 1
    end
    if grid[y % grid.length][(x-1) % grid[0].length] == "."
      new_positions[[y, x-1]] ||= 0
      new_positions[[y, x-1]] += 1
    end

  end

  positions = new_positions
end

totals = {}
check_positions.each do |grid_position|
  total = 0
  positions.each do |position, _|
    next if position[0] < grid.length*grid_position[0] || position[1] < grid[0].length*grid_position[1]  || position[0] >= grid.length*(grid_position[0]+1) || position[1] >= grid[0].length*(grid_position[1]+1)
    total += 1
  end
  totals[grid_position] = total
end

small_grid = new_grid 11, 11, 0
small_grid.each_with_index do |row, y|
  row.each_with_index do |_, x|
    small_grid[y][x] = 7577 if (y-5).abs + (x-5).abs < 4 && (((y-5).even? && (x-5).even?) || ((y-5).odd? && (x-5).odd?))
    small_grid[y][x] = 7596 if (y-5).abs + (x-5).abs < 4 && (((y-5).even? && (x-5).odd?) || ((y-5).odd? && (x-5).even?))
  end
end
totals.each do |position, total|
  small_grid[5+position[0]][5+position[1]] = total
end

print_grid small_grid, " ", nil, false, true

total = 0
total += ((clean_cycles + 1) ** 2) * 7596
total += ((clean_cycles) ** 2) * 7577
total += (clean_cycles + 1) * (small_grid[6][9] + small_grid[6][1] + small_grid[4][9] + small_grid[4][1])
total += (clean_cycles) * (small_grid[2][4] + small_grid[2][6] + small_grid[8][4] + small_grid[8][6])
total += small_grid[5][1] + small_grid[5][9] + small_grid[1][5] + small_grid[9][5]

puts total



# 7577
# 7596

# center fills at 129 , and has odd for 7577

# Corners fill at 522, and all have odd 7596
# top and bottom fill at 260, and has odd for 7596

# top left rigt and bottom two away fill at 391, and has odd for 7577

# left and right three away fill at 522, and have odd for 7596
# bottom three away fills at 522, and has odd for 7596

# bottom four away fills at 653, odds for 7577

# corner at 653, odds for 7577


# 202299 + 1 + 202299
# 265 -> 62512

# 26501365 should be in balpark of 625120000000000

# too low
# 620960612062934
# 620962518734027

# correct for 1000 - 886426
