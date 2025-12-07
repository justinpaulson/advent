require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
g = Grid.new(lines)

@beam_splits = 0

beam_start = g.find("S")

g.grid[beam_start[0]+1][beam_start[1]] = "|"

def move_beams g
  return_val = false
  beams = g.find_all("|")
  beams.each do |beam|
    y,x = beam
    next if y+1 >= g.grid.length || g.grid[y+1][x] == "|"
    below = g.grid[y+1][x]
    if below == "."
      g.grid[y+1][x] = "|"
      return_val = true
    elsif below == "^"
      next if g.grid[y+1][x-1] == "|" && g.grid[y+1][x+1] == "|"
      g.grid[y+1][x+1] = "|"
      g.grid[y+1][x-1] = "|"
      @beam_splits += 1
      return_val = true
    end
  end
  return_val
end

while move_beams g
end
puts @beam_splits

g = Grid.new(lines)

@count_paths = {}
def count_paths g, position
  return @count_paths[position] if @count_paths.key?(position)
  y, x = position
  if y == g.grid.length - 1
    @count_paths[position] = 1
    return 1
  end

  below = g.grid[y+1][x]
  if below == "."
    @count_paths[[y+1, x]] = count_paths(g, [y+1, x])
    return @count_paths[[y+1, x]]
  elsif below == "^"
    @count_paths[[y+1, x-1]] = count_paths(g, [y+1, x-1])
    @count_paths[[y+1, x+1]] = count_paths(g, [y+1, x+1])
    return @count_paths[[y+1, x-1]] + @count_paths[[y+1, x+1]]
  end
end

start_position = g.find("S")

puts count_paths(g, start_position)
