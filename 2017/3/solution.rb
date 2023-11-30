load "../../grid.rb"

inp = 368078

ring = 1
square = 1
i = 1
sq = 1

while sq < inp
  i += 2
  sq = i*i
  square = sq
  ring += 1
end

times = 0
corner = square

while corner > inp
  times += 1 
  corner = corner - (i-1)
end

center = ((square - ((times -1) * (i-1))) - corner)/2 + corner

puts ring - 1 + (inp - center).abs


grid = []

50.times{ grid << 1.upto(50).map{0} }

# puts grid.to_s

def place_grid grid, cursor
  grid[cursor[0]][cursor[1]] = grid[cursor[0]][cursor[1]-1] + grid[cursor[0]][cursor[1]+1] +
  grid[cursor[0]-1][cursor[1]] +  grid[cursor[0]+1][cursor[1]] +
  grid[cursor[0]-1][cursor[1]-1] +  grid[cursor[0]+1][cursor[1]-1] +  
  grid[cursor[0]-1][cursor[1]+1] + grid[cursor[0]+1][cursor[1]+1]
  # puts grid[cursor[0]][cursor[1]]
  grid
rescue NoMethodError => e
  puts cursor
  raise e
end

grid[25][25] = 1

cursor = [26,25]
ring = 2
count_for_ring = 0
while true
  grid = place_grid grid, cursor
  count_for_ring += 1
  (puts grid[cursor[0]][cursor[1]]; return) if grid[cursor[0]][cursor[1]] > inp
  if (count_for_ring == 1 && cursor == [500,500]) || count_for_ring >= ((ring - 1) * 8 * 3/4)
    cursor = [cursor[0]+1,cursor[1]]
  elsif count_for_ring >= ((ring - 1) * 8 * 1/2)
    cursor = [cursor[0],cursor[1]+1]
  elsif count_for_ring >= ((ring - 1) * 8 * 1/4)
    cursor = [cursor[0]-1,cursor[1]]
  else
    cursor = [cursor[0],cursor[1]-1]
  end
  (count_for_ring = 0; ring += 1) if count_for_ring == (ring-1)*8
end
