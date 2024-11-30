require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
stars = lines.map do |line|
  position, velocity = line.split("> velocity=<")
  position = position.split("<")[1].split(",").map(&:to_i)
  velocity = velocity.split(">")[0].split(",").map(&:to_i)
  [position, velocity]
end

def max_y(stars)
  stars.map(&:first).map(&:last).max
end

def min_y(stars)
  stars.map(&:first).map(&:last).min
end

def min_x(stars)
  stars.map(&:first).map(&:first).min
end

def max_x(stars)
  stars.map(&:first).map(&:first).max
end

steps = 0
while (max_y(stars) - min_y(stars)) > 10
  stars.each do |star|
    star[0][0] += star[1][0]
    star[0][1] += star[1][1]
  end
  steps += 1
end

grid = new_grid(max_y(stars) - min_y(stars) + 1, max_x(stars) - min_x(stars) + 1, ".")

stars.each do |star|
  grid[star[0][1] - min_y(stars)][star[0][0] - min_x(stars)] = "#"
end

print_grid(grid)
puts steps
