require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
g = Grid.new(lines)

total = 0
g.grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    next unless cell == "@"
    adjacent = g.find_all_eight_adjacent([y, x], "@")
    total += 1 if adjacent.size < 4
  end
end

puts total

def clear_rolls g
  total = 0
  removals = []
  g.grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      next unless cell == "@"
      adjacent = g.find_all_eight_adjacent([y, x], "@")
      if adjacent.size < 4
        total += 1
        removals << [y, x]
      end
    end
  end
  removals.each do |y, x|
    g.grid[y][x] = "."
  end
  total
end

old_removed = 0
removed = clear_rolls(g)
while old_removed != removed
  old_removed = removed
  removed += clear_rolls(g)
end

puts removed
