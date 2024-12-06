require '../../grid.rb'
ARGV[0] ||= "input"

def run_grid g
  guard = g.grid.each_with_index.map do |row, y|
    row.each_with_index.map do |cell, x|
      if cell == "^"
        [y,x]
      else
        nil
      end
    end.compact
  end.flatten

  grids = []
  grids << g.grid

  while true
    g = Grid.new(g.grid)
    # g.print_grid
    case g.grid[guard[0]][guard[1]]
    when "^"
      if guard[0] == 0
        g.grid[guard[0]][guard[1]] = "X"
        break
      elsif g.grid[guard[0]-1][guard[1]] == "#"
        g.grid[guard[0]][guard[1]] = ">"
      else
        g.grid[guard[0]][guard[1]] = "X"
        g.grid[guard[0]-1][guard[1]] = "^"
        guard = [guard[0]-1,guard[1]]
      end
    when ">"
      if guard[1] == g.grid[0].length - 1
        g.grid[guard[0]][guard[1]] = "X"
        break
      end
      if g.grid[guard[0]][guard[1]+1] == "#"
        g.grid[guard[0]][guard[1]] = "v"
      else
        g.grid[guard[0]][guard[1]] = "X"
        g.grid[guard[0]][guard[1]+1] = ">"
        guard = [guard[0],guard[1]+1]
      end
    when "v"
      if guard[0] == g.grid.length - 1
        g.grid[guard[0]][guard[1]] = "X"
        break
      end
      if g.grid[guard[0]+1][guard[1]] == "#"
        g.grid[guard[0]][guard[1]] = "<"
      else
        g.grid[guard[0]][guard[1]] = "X"
        g.grid[guard[0]+1][guard[1]] = "v"
        guard = [guard[0]+1,guard[1]]
      end
    when "<"
      if guard[1] == 0
        g.grid[guard[0]][guard[1]] = "X"
        break
      elsif g.grid[guard[0]][guard[1]-1] == "#"
        g.grid[guard[0]][guard[1]] = "^"
      else
        g.grid[guard[0]][guard[1]] = "X"
        g.grid[guard[0]][guard[1]-1] = "<"
        guard = [guard[0],guard[1]-1]
      end
    end
    if grids.include? g.grid
      return false
    else
      grids << g.grid
    end
  end

  return g
end

lines = IO.readlines(ARGV[0]).map(&:chomp)

initial_guard = lines.each_with_index.map do |line, y|
  line.chars.each_with_index.map do |char, x|
    if char == "^"
      [y,x]
    else
      nil
    end
  end.compact
end.flatten

g = Grid.new(lines)

g = run_grid g

puts g.grid.flatten.count("X")

possible_obstructions = g.grid.each_with_index.map do |row, y|
  row.each_with_index.map do |cell, x|
    if cell == "X"
      [y,x] unless initial_guard == [y,x]
    else
      nil
    end
  end.compact
end.flatten(1)

puts "Warning, may take two or three days, try solution2!"
total = 0
count = 0
possible_obstructions.map do |obstruction|
  count += 1
  g = Grid.new(lines)
  g.grid[obstruction[0]][obstruction[1]] = "#"
  total += 1 if !run_grid(g)
  puts "#{count}/#{possible_obstructions.length} total so far: #{total}"
end

puts total


# too high
# 1773
