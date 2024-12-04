
require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

total = 0

xs = []
ms = []
g = Grid.new(lines)
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    xs << [y,x] if char == 'X'
    ms << [y,x] if char == 'M'
  end
end

grid = g.grid

xs.each do |y,x|
  if y > 2
    total += 1 if grid[y-1][x] == 'M' && grid[y-2][x] == 'A' && grid[y-3][x] == 'S'
    if x > 2
      total += 1 if grid[y-1][x-1] == 'M' && grid[y-2][x-2] == 'A' && grid[y-3][x-3] == 'S'
    end
    if x < grid[0].length - 3
      total += 1 if grid[y-1][x+1] == 'M' && grid[y-2][x+2] == 'A' && grid[y-3][x+3] == 'S'
    end
  end
  if y < grid.length - 3
    total += 1 if grid[y+1][x] == 'M' && grid[y+2][x] == 'A' && grid[y+3][x] == 'S'
    if x > 2
      total += 1 if grid[y+1][x-1] == 'M' && grid[y+2][x-2] == 'A' && grid[y+3][x-3] == 'S'
    end
    if x < grid[0].length - 3
      total += 1 if grid[y+1][x+1] == 'M' && grid[y+2][x+2] == 'A' && grid[y+3][x+3] == 'S'
    end
  end
  if x > 2
    total += 1 if grid[y][x-1] == 'M' && grid[y][x-2] == 'A' && grid[y][x-3] == 'S'
  end
  if x < grid[0].length - 3
    total += 1 if grid[y][x+1] == 'M' && grid[y][x+2] == 'A' && grid[y][x+3] == 'S'
  end
end

puts total

total = 0
found_as = []
ms.each do |y,x|
  if y > 1
    if x > 1
      # S M
      #  A
      # S M
      if grid[y-1][x-1] == 'A' && grid[y-2][x-2] == 'S' && grid[y-2][x] == 'M' && grid[y][x-2] == 'S'
        unless found_as.include?([y-1,x-1])
          total += 1
          found_as << [y-1,x-1]
        end
      end

      # S S
      #  A
      # M M
      if grid[y-1][x-1] == 'A' && grid[y-2][x] == 'S' && grid[y-2][x-2] == 'S' && grid[y][x-2] == 'M'
        unless found_as.include?([y-1,x-1])
          total += 1
          found_as << [y-1,x-1]
        end
      end
    end
  end
  if y < grid.length - 2
    if x < grid[0].length - 2
      # M M
      #  A
      # S S
      if grid[y+1][x+1] == 'A' && grid[y+2][x+2] == 'S' && grid[y][x+2] == 'M' && grid[y+2][x] == 'S'
        unless found_as.include?([y+1,x+1])
          total += 1
          found_as << [y+1,x+1]
        end
      end

      # M S
      #  A
      # M S
      if grid[y+1][x+1] == 'A' && grid[y+2][x] == 'M' && grid[y][x+2] == 'S' && grid[y+2][x+2] == 'S'
        unless found_as.include?([y+1,x+1])
          total += 1
          found_as << [y+1,x+1]
        end
      end
    end
  end
end

puts total
