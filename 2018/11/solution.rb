require '../../grid.rb'
ARGV[0] ||= "input"
input = IO.read(ARGV[0]).to_i

# input = 18

grid = new_grid 301, 301

1.upto(300) do |x|
  1.upto(300) do |y|
    rack_id = x + 10
    power = rack_id * y
    power += input
    power *= rack_id
    if power >= 100
      power = (power / 100) % 10
    else
      power = 0
    end
    power -= 5
    grid[y][x] = power
  end
end

max = 0
coords = []
1.upto(298) do |x|
  1.upto(298) do |y|
    total = grid[y][x..x+2].sum + grid[y+1][x..x+2].sum + grid[y+2][x..x+2].sum
    if total > max
      max = total
      coords = [x, y]
    end
  end
end

puts coords.join(",")

# sloooooooooooooooooow
4.upto(300) do |size|
  1.upto(301-size) do |x|
    1.upto(301-size) do |y|
      total = 0.upto(size-1).map{|yo| grid[y + yo][x..x+size-1].sum}.sum
      if total > max
        max = total
        coords = [x, y, size]
      end
    end
  end
end

puts coords.join(",")
