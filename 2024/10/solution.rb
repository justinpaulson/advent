require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
g = Grid.new(lines)


trailheads = []

g.grid.each_with_index do |row, y|
  row.each_with_index do |val, x|
    trailheads << [y, x] if val == "0"
  end
end


def score g, trailhead
  paths = []

  nines = []
  if trailhead[0] > 0 && g.grid[trailhead[0] - 1][trailhead[1]] == 1
    paths << [[trailhead[0] - 1, trailhead[1]]]
  end
  if trailhead[0] < g.grid.length - 1 && g.grid[trailhead[0] + 1][trailhead[1]] == 1
    paths << [[trailhead[0] + 1, trailhead[1]]]
  end
  if trailhead[1] > 0 && g.grid[trailhead[0]][trailhead[1] - 1] == 1
    paths << [[trailhead[0], trailhead[1] - 1]]
  end
  if trailhead[1] < g.grid[0].length - 1 &&  g.grid[trailhead[0]][trailhead[1] + 1] == 1
    paths << [[trailhead[0], trailhead[1] + 1]]
  end
  position = trailhead
  while paths.any? do
    position = paths.shift[0]
    previous = g.grid[position[0]][position[1]]
    if previous == 9
      nines << position
      next
    end
    if position[0] > 0 && g.grid[position[0] - 1][position[1]] == previous + 1
      paths << [[position[0] - 1, position[1]]]
    end
    if position[0] < g.grid.length - 1 && g.grid[position[0] + 1][position[1]] == previous + 1
      paths << [[position[0] + 1, position[1]]]
    end
    if position[1] > 0 && g.grid[position[0]][position[1] - 1] == previous + 1
      paths << [[position[0], position[1] - 1]]
    end
    if position[1] < g.grid[0].length - 1 && g.grid[position[0]][position[1] + 1] == previous + 1
      paths << [[position[0], position[1] + 1]]
    end
  end
  [nines.uniq.length, nines.length]
end


g.grid = g.grid.map! do |row|
  row.map do |val|
    val.to_i
  end
end

total1 = 0
total2 = 0
trailheads.each do |trailhead|
  t_score = score(g, trailhead)
  total1 += t_score[0]
  total2 += t_score[1]
end

puts total1
puts total2
