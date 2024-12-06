require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
grid = Grid.new(lines).grid

def adjacent_cells grid, x, y
  adj = []
  if x > 0
    adj << grid[y][x-1]
    adj << grid[y-1][x-1] if y > 0
    adj << grid[y+1][x-1] if y < grid.length - 1
  end
  if x < grid[0].length - 1
    adj << grid[y][x+1]
    adj << grid[y-1][x+1] if y > 0
    adj << grid[y+1][x+1] if y < grid.length - 1
  end
  adj << grid[y-1][x] if y > 0
  adj << grid[y+1][x] if y < grid.length - 1
  adj
end

grids = {}
totals = []

puts "Warning: part 2 takes a couple days!"
1000000000.times do |count|
  if grids[grid]
    # puts "now we cook!"
    grid = grids[grid]
    puts "#{count}/1000000000" if count % 10000 == 0
    next
  end
  updated_grid = Grid.new(grid.length, grid[0].length).grid
  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      adj = adjacent_cells grid, x, y
      updated_grid[y][x] = case cell
      when '.'
        adj.count('|') >= 3 ? '|' : '.'
      when '|'
        adj.count('#') >= 3 ? '#' : '|'
      when '#'
        adj.count('#') >= 1 && adj.count('|') >= 1 ? '#' : '.'
      end
    end
  end
  grids[grid] = updated_grid
  grid = updated_grid
  puts grid.flatten.count('#') * grid.flatten.count('|') if count == 9
  # Failed attempt at detecting cycles.....
  # if totals.include?(updated_grid.flatten.count('#') * updated_grid.flatten.count('|'))
  # if grids.include?(grid)
  #   puts "Cycle detected at #{count}"
  #   first_cycle_index = count
  #   puts "Total here: #{grid.flatten.count('#') * grid.flatten.count('|')}"
  #   first_appearance = grids.index(grid)
  #   puts "First appearance total: #{totals[first_appearance]}"
  #   cycle_length = first_cycle_index - first_appearance
  #   puts "Cycle length: #{cycle_length}"
  #   cycle_index = (1000000000 - first_appearance - 1) % cycle_length
  #   puts "Cycle index: #{cycle_index}"
  #   cycle_grid = grids[first_appearance + cycle_index - 1]
  #   puts cycle_grid.flatten.count('#') * cycle_grid.flatten.count('|')
  #   break
  # end
  puts "#{count}/1000000000" if count % 10000 == 0
end

puts grid.flatten.count('#') * grid.flatten.count('|')


####################################################################################################

###################123456781234567812345678123456781234567812345678123456781234567812345678123456781



# answer = 7
# first_cycle_index = 27
# first_appearance = 19
# cycle_length = first_cycle_index - first_appearance = 8

# 100 - first_appearance - 1 = 80
# 101 - first_appearance - 1 = 81
# 81 % 8 = 0
# 82 % 8 = 1
# 19 + 0 = 19
# @ 100 = 7
