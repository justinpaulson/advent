load "../../grid.rb"

def clear_claim? count_grid, claim
  id, x, y, w, h = claim
  0.upto(w-1) do |x_off|
    0.upto(h-1) do |y_off|
      return false if count_grid[x+x_off][y+y_off] > 1
    end
  end
  true
end

count_grid = new_grid 1000,1000,0

lines = File.readlines("input")

claims = []

lines.each do |line|
  id, claim = line.split(" @ ")
  xy, area = claim.split(": ")
  x,y = xy.split(",").map(&:to_i)
  w,h = area.split("x").map(&:to_i)
  0.upto(w-1) do |place_x|
    0.upto(h-1) do |place_y|
      count_grid[x+place_x][y+place_y] += 1
    end
  end
  claims << [id, x, y, w, h]
end

p count_grid.sum{|arr| arr.map{|cell| cell > 1 ? 1 : 0}.sum}

claims.each do |claim|
  puts claim[0] if clear_claim? count_grid, claim
end
