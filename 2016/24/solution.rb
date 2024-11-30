require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
@grid = new_grid lines.length, lines[0].length
start = nil
@points = []
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    start = [y,x] if char == "0"
    @points << [y,x] if char =~ /\d/
    char = "." if char =~ /\d/
    @grid[y][x] = char
  end
end

# To calculate the distances between each of the points we will need to visit
# I used the following A*...
# Then I put in the distances I got from the hash into an input file.
def is_goal? point
  point == @goal
end

def get_neighbors point, path
  neighbors = []
  y,x = point
  [[y+1,x],[y-1,x],[y,x+1],[y,x-1]].each do |new_point|
    if @grid[new_point[0]][new_point[1]] != "#"
      neighbors << new_point if !path.include?(new_point)
    end
  end
  neighbors
end

def score_for_neighbor point, new_point
  1
end

def h point
  (point[0] - @goal[0]).abs + (point[1] - @goal[1]).abs
end

@distances = {}
@distances = eval(File.read("distances")) if File.exist?("distances")

@points.each do |point|
  @goal = point
  @points.each do |other_point|
    next if point == other_point
    next if @distances[[point,other_point]] || @distances[[other_point,point]]
    @goal = other_point
    @distances[[point,other_point]] = a_star(point).last
    @distances[[other_point,point]] = @distances[[point,other_point]]
  end
end

# puts @distances.to_s

# def is_goal? point
#   point.length == @points.length
# end

# def get_neighbors point, path
#   @points.select{|p| !path.include?(p)}
# end

# def score_for_neighbor point, new_point
#   @distances[[point,new_point]]
# end

# def h point, path
#   @points.select{|po| !path.include?(po)}.map{|po| @distances[[point,po]]}.sum
# end

# def print_a_star curr_point, lowest, neighbors, set, from, g, f
#   puts "curr_point: #{curr_point}"
#   puts "lowest: #{lowest}"
#   puts "neighbors: #{neighbors}"
#   puts "set: #{set}"
#   puts "from: #{from}"
#   puts "g: #{g}"
#   puts "f: #{f}"
#   puts "Path: #{reconstruct_path(from,curr_point)}"
#   puts
# end

# puts a_star(start).last

@points = @points - [start]
min_distance = 99999999
@points.permutation.each do |perm|
  # path = [start] + perm # part 1
  path = [start] + perm + [start] # part 2
  distance = 0
  path.each_with_index do |point, index|
    next_point = path[index+1]
    break if next_point.nil?
    distance += @distances[[point,next_point]]
  end
  min_distance = distance if distance < min_distance
end

puts min_distance
