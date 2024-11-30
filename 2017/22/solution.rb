require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
grid = {}
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    grid[[y,x]] = char
  end
end

direction = "^"
current = [(lines.length - 1)/2, (lines[0].length-1)/2]
count = 0
10000.times do
  grid[current] ||= "."
  if grid[current] == "."
    count += 1
    grid[current] = "#"
    case direction
    when "^"
      direction = "<"
      current[1] -= 1
    when ">"
      direction = "^"
      current[0] -= 1
    when "v"
      direction = ">"
      current[1] += 1
    when "<"
      direction = "v"
      current[0] += 1
    end
  else
    grid[current] = "."
    case direction
    when "^"
      direction = ">"
      current[1] += 1
    when ">"
      direction = "v"
      current[0] += 1
    when "v"
      direction = "<"
      current[1] -= 1
    when "<"
      direction = "^"
      current[0] -= 1
    end
  end
end

puts count

def print_hash_grid grid
  grid.keys.map(&:first).min.upto(grid.keys.map(&:first).max) do |y|
    grid.keys.map(&:last).min.upto(grid.keys.map(&:last).max) do |x|
      print grid[[y,x]] || " "
    end
    puts
  end
end


# part 2!!

grid = {}
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    grid[[y,x]] = char
  end
end

direction = "^"
current = [(lines.length - 1)/2, (lines[0].length - 1)/2]
count = 0
10000000.times do
  grid[current.clone] ||= "."
  if grid[current.clone] == "."
    grid[current.clone] = "W"
    case direction
    when "^"
      direction = "<"
      current[1] -= 1
    when ">"
      direction = "^"
      current[0] -= 1
    when "v"
      direction = ">"
      current[1] += 1
    when "<"
      direction = "v"
      current[0] += 1
    end
  elsif grid[current.clone] == "W"
    count += 1
    grid[current.clone] = "#"
    case direction
    when "^"
      current[0] -= 1
    when ">"
      current[1] += 1
    when "v"
      current[0] += 1
    when "<"
      current[1] -= 1
    end
  elsif grid[current.clone] == "#"
    grid[current.clone] = "F"
    case direction
    when "^"
      direction = ">"
      current[1] += 1
    when ">"
      direction = "v"
      current[0] += 1
    when "v"
      direction = "<"
      current[1] -= 1
    when "<"
      direction = "^"
      current[0] -= 1
    end
  else
    grid[current.clone] = "."
    case direction
    when "^"
      direction = "v"
      current[0] += 1
    when ">"
      direction = "<"
      current[1] -= 1
    when "v"
      direction = "^"
      current[0] -= 1
    when "<"
      direction = ">"
      current[1] += 1
    end
  end
end

puts count
