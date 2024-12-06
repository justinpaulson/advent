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
    case g.grid[guard[0]][guard[1]]
    when "^"
      if guard[0] == 0
        g.grid[guard[0]][guard[1]] = "|"
        break
      elsif ["|","+"].include?(g.grid[guard[0]-1][guard[1]])
        next_y = guard[0]
        while next_y < g.grid.length
          next_y -= 1
          if g.grid[next_y][guard[1]] == "."
            guard = [next_y,guard[1]]
            g.grid[guard[0]][guard[1]] = "^"
            break
          end
          return false if g.grid[next_y][guard[1]] == "#"
        end
      elsif g.grid[guard[0]-1][guard[1]] == "#"
        g.grid[guard[0]][guard[1]] = ">"
      else
        g.grid[guard[0]][guard[1]] = "|"
        g.grid[guard[0]][guard[1]] = "+" if (g.grid[guard[0]][guard[1]+1] == "-" || g.grid[guard[0]][guard[1]+1] == "+" || g.grid[guard[0]][guard[1]+1] == "#") && (g.grid[guard[0]][guard[1]-1] == "-"  || g.grid[guard[0]][guard[1]-1] == "+" || g.grid[guard[0]][guard[1]-1] == "#")
        g.grid[guard[0]-1][guard[1]] = "^"
        guard = [guard[0]-1,guard[1]]
      end
    when ">"
      if guard[1] == g.grid[0].length - 1
        g.grid[guard[0]][guard[1]] = "-"
        break
      elsif ["-","+"].include?(g.grid[guard[0]][guard[1]+1])
        next_x = guard[1]
        while next_x < g.grid[0].length
          next_x += 1
          if g.grid[guard[0]][next_x] == "."
            guard = [guard[0],next_x]
            g.grid[guard[0]][guard[1]] = ">"
            break
          end
          return false if g.grid[guard[0]][next_x] == "#"
        end
      elsif g.grid[guard[0]][guard[1]+1] == "#"
        g.grid[guard[0]][guard[1]] = "v"
      else
        g.grid[guard[0]][guard[1]] = "-"
        g.grid[guard[0]][guard[1]] = "+" if (g.grid[guard[0]+1][guard[1]] == "|" || g.grid[guard[0]+1][guard[1]] == "+" || g.grid[guard[0]+1][guard[1]] == "#") && (g.grid[guard[0]-1][guard[1]] == "|" || g.grid[guard[0]-1][guard[1]] == "+" || g.grid[guard[0]-1][guard[1]] == "#")
        g.grid[guard[0]][guard[1]+1] = ">"
        guard = [guard[0],guard[1]+1]
      end
    when "v"
      if guard[0] == g.grid.length - 1
        g.grid[guard[0]][guard[1]] = "|"
        break
      elsif ["|","+"].include?(g.grid[guard[0]+1][guard[1]])
        next_y = guard[0]
        while next_y < g.grid.length
          next_y += 1
          if g.grid[next_y][guard[1]] == "."
            guard = [next_y,guard[1]]
            g.grid[guard[0]][guard[1]] = "v"
            break
          end
          return false if g.grid[next_y][guard[1]] == "#"
        end
      elsif g.grid[guard[0]+1][guard[1]] == "#"
        g.grid[guard[0]][guard[1]] = "<"
      else
        g.grid[guard[0]][guard[1]] = "|"
        g.grid[guard[0]][guard[1]] = "+" if (g.grid[guard[0]][guard[1]+1] == "-" || g.grid[guard[0]][guard[1]+1] == "+" || g.grid[guard[0]][guard[1]+1] == "#") && (g.grid[guard[0]][guard[1]-1] == "-" || g.grid[guard[0]][guard[1]-1] == "+" || g.grid[guard[0]][guard[1]-1] == "#")
        g.grid[guard[0]+1][guard[1]] = "v"
        guard = [guard[0]+1,guard[1]]
      end
    when "<"
      if guard[1] == 0
        g.grid[guard[0]][guard[1]] = "-"
        break
      elsif ["-","+"].include?(g.grid[guard[0]][guard[1]-1])
        next_x = guard[1]
        while next_x > 0
          next_x -= 1
          if g.grid[guard[0]][next_x] == "."
            guard = [guard[0],next_x]
            g.grid[guard[0]][guard[1]] = "<"
            break
          end
          return false if g.grid[guard[0]][next_x] == "#"
        end
      elsif g.grid[guard[0]][guard[1]-1] == "#"
        g.grid[guard[0]][guard[1]] = "^"
      else
        g.grid[guard[0]][guard[1]] = "-"
        g.grid[guard[0]][guard[1]] = "+" if (g.grid[guard[0]+1][guard[1]] == "|" || g.grid[guard[0]+1][guard[1]] == "+"  || g.grid[guard[0]+1][guard[1]] == "#") && (g.grid[guard[0]-1][guard[1]] == "|" || g.grid[guard[0]-1][guard[1]] == "+" || g.grid[guard[0]-1][guard[1]] == "#")
        g.grid[guard[0]][guard[1]-1] = "<"
        guard = [guard[0],guard[1]-1]
      end
    end
  end

  return g
end

lines = IO.readlines(ARGV[0]).map(&:chomp)

g = Grid.new(lines)

g = run_grid g

puts g.grid.flatten.count("-") + g.grid.flatten.count("|") + g.grid.flatten.count("+") + g.grid.flatten.count("v") + g.grid.flatten.count("^") + g.grid.flatten.count(">") + g.grid.flatten.count("<")

initial_guard = lines.each_with_index.map do |row, y|
  row.chars.each_with_index.map do |cell, x|
    if cell == "^"
      [y,x]
    else
      nil
    end
  end.compact
end.compact.flatten

possible_obstructions = g.grid.each_with_index.map do |row, y|
  row.each_with_index.map do |cell, x|
    if ["-","|","+"].include?(cell) && initial_guard != [y,x]
      [y,x]
    else
      nil
    end
  end.compact
end.flatten(1)

total = 0
count = 0
possible_obstructions.map do |obstruction|
  count += 1
  g = Grid.new(lines)
  g.grid[obstruction[0]][obstruction[1]] = "#"
  total += 1 if !run_grid(g)
end

puts total
