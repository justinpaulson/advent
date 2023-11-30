load "../../grid.rb"
lines = File.readlines("input").map{|l| l.split.map(&:to_i)}

max = lines.map{|l| l.max}.max

grid = new_grid max,max,"."

points = []
letters = []

lines.each_with_index do |(x,y),i|
  grid[x][y] = i >=26 ? ("A".ord+i%26).chr * 2 : ("A".ord+i%26).chr
  points << [x,y]
  letters << (i >=26 ? ("A".ord+i%26).chr * 2 : ("A".ord+i%26).chr)
end

infinites = []

0.upto(grid.length-1) do |x|
  0.upto(grid[0].length-1) do |y|
    next if points.include?([x,y])
    min = 5000
    minp = []
    points.each do |px,py|
      dist = (x - px).abs + (y - py).abs
      (min = dist; minp=[px,py]) if dist < min
    end
    tie = false
    points.each do |tx,ty|
      next if tx==minp[0] || ty==minp[1]
      tie = true if min == (x - tx).abs + (y - ty).abs
    end
    grid[x][y] = tie ? "." : grid[minp[0]][minp[1]].downcase
    if (x==0 || y==0 || x==grid.length-1 || y==grid[0].length-1) && !tie
      infinites << grid[x][y]
      infinites = infinites.uniq
    end
  end
end

totals = {}

letters = letters.select{|l| !infinites.include?(l.downcase)}

grid.map do |line|
  letters.each do |l|
    totals[l] ||= 1 # account for the point itself.
    totals[l] += line.count(l.downcase)
  end
end

puts totals.values.max

grid = new_grid max,max,0

0.upto(grid.length-1) do |x|
  0.upto(grid[0].length-1) do |y|
    points.each do |px,py|
      dist = (x - px).abs + (y - py).abs
      grid[x][y] += dist
    end
    grid[x][y] = grid[x][y] < 10000 ? "#" : "."
  end
end

puts grid.map{|line| line.count("#")}.sum
