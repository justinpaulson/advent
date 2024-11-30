require '../../grid.rb'
ARGV[0] ||= "input"

@input = 1350

def wall? x, y
  (x*x + 3*x + 2*x*y + y + y*y + @input).to_s(2).count("1") % 2 == 1
end

def is_goal? point
  point == @goal
end

def get_neighbors point, path
  neighbors = []
  x, y = point
  neighbors << [x-1, y] if x > 0 && !wall?(x-1, y) && !path.include?([x-1,y])
  neighbors << [x+1, y] if !wall?(x+1, y) && !path.include?([x+1,y])
  neighbors << [x, y-1] if y > 0 && !wall?(x, y-1) && !path.include?([x,y-1])
  neighbors << [x, y+1] if !wall?(x, y+1) && !path.include?([x,y+1])
  neighbors
end

def score_for_neighbor point, neighbor
  1
end

def h point
  (point[0] - @goal[0]).abs + (point[1] - @goal[1]).abs
end

@max_count = 0
def print_a_star curr_point, lowest, neighors, set, from, g, f
  if g.select{|k,v| v <= 50}.count > @max_count
    @max_count = g.select{|k,v| v <= 50}.count
  end
  return
  puts "Current: #{curr_point}"
  puts "Lowest: #{lowest}"
  puts "Neighbors: #{neighbors}"
  puts "Set: #{set}"
  puts "From: #{from}"
  puts "G: #{g}"
  puts "F: #{f}"
end

@goal = [31,39]

puts a_star([1,1]).last

@goal = [1000,10000]
@max_count = 0

a_star([1,1])

puts @max_count
