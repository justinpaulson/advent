require '../../grid.rb'
ARGV[0] ||= "input"
width = 101
height = 103
if ARGV[0] == 'test'
  width = 11
  height = 7
end
lines = IO.readlines(ARGV[0]).map(&:chomp)
g = Grid.new(height, width, 0)

robots = []
lines.each do |line|
  point, velocity = line.split(" v=")
  point = point.split("p=")[1].split(",").map(&:to_i)
  velocity = velocity.split(",").map(&:to_i)
  robots << [point, velocity]
  g.grid[point[1]][point[0]] += 1
end

def move_robots grid, robots
  robots.each do |robot|
    grid[robot[0][1]][robot[0][0]] -= 1
    robot[0][0] = (robot[0][0] + robot[1][0]) % grid[0].length
    robot[0][1] = (robot[0][1] + robot[1][1]) % grid.length
    grid[robot[0][1]][robot[0][0]] += 1
  end
  return grid, robots
end

100.times do
  g.grid, robots = move_robots g.grid, robots
end

def score_grid grid, width, height
  quad1 = grid[0..height/2-1].map do |row|
    row[0..width/2-1].sum
  end.sum

  quad2 = grid[0..height/2-1].map do |row|
    row[width/2+1..-1].sum
  end.sum

  quad3 = grid[height/2+1..-1].map do |row|
    row[0..width/2-1].sum
  end.sum

  quad4 = grid[height/2+1..-1].map do |row|
    row[width/2+1..-1].sum
  end.sum

  return quad1 * quad2 * quad3 * quad4
end

def long_vertical grid
  total_mids = {}
  grid.each do |row|
    0.upto(row.length-1) do |col|
      total_mids[col] ||= 0
      total_mids[col] += row[col]
    end
  end

  total_mids.values.any?{|col| col > grid.length * 0.5}
end

def long_horizontal grid
  grid.each do |row|
    return true if row.each_cons(15).any?{ |c| c == [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] }
  end
  false
end

puts score_grid(g.grid, width, height)

count = 101
while true
  g.grid, robots = move_robots g.grid, robots
  if long_horizontal(g.grid)
    puts count
    exit
  end
  count += 1
end
