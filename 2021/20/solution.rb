load "../../grid.rb"

@algo = IO.readlines("input")[0]
image = IO.readlines("input")[2..-1].map{|l| l.chomp.chars}

grid = new_grid image.length + 1000, image[0].length + 1000, "."

image.each_with_index do |line, y|
  line.each_with_index do |c, x|
    grid[y+450][x+450] = c
  end
end

def update grid, y, x
  out = grid[y-1][x-1..x+1] + grid[y][x-1..x+1] + grid[y+1][x-1..x+1]
  index = out.map{|c| c=="#" ? "1" : "0"}.join.to_i(2)
  # puts out.map{|c| c=="#" ? "1" : "0"}.join unless index == 0
  # puts index  unless index == 0
  @algo[out.map{|c| c=="#" ? "1" : "0"}.join.to_i(2)]
end

p grid.sum{|l| l.sum{|c| c=="#"? 1: 0}}


times = 50

min = 340
max = 660

while times > 0
  times -= 1
  puts 50-times
  n_grid = new_grid grid.length, grid[0].length, "."

  (1).upto(998) do |y|
    (1).upto(998) do |x|
      n_grid[y][x] = update grid, y, x
    end
  end

  grid = n_grid
end

pg = new_grid max - min, max - min, "."

min.upto(max) do |y|
  pg[y-min] = grid[y][min..max]
end

print_grid pg

p pg.sum{|l| l.sum{|c| c=="#"? 1: 0}}
