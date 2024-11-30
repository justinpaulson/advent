require '../../grid.rb'
ARGV[0] ||= "input"
steps = IO.read(ARGV[0]).chomp.split(",")

start = [0,0]
@child = [0,0]

max_x = 0
steps.each do |step|
  case step
  when 'n'
    @child[1] -= 2
  when 'ne'
    @child[0] += 1
    @child[1] -= 1
  when 'nw'
    @child[0] -= 1
    @child[1] -= 1
  when 's'
    @child[1] += 2
  when 'se'
    @child[0] += 1
    @child[1] += 1
  when 'sw'
    @child[0] -= 1
    @child[1] += 1
  end
  max_x = [@child[0], max_x].max
end

puts @child[0] if @child[0] > @child[1] * 2

puts max_x

# not necessary, but it worked pretty quick :D
#
# def is_goal? point
#   point == @child
# end

# def get_neighbors point, path
#   neighbors = []
#   [[0,2],[1,1],[1,-1],[0,-2],[-1,-1],[-1,1]].each do |neighbor|
#     neighbors << [point[0] + neighbor[0], point[1] + neighbor[1]]
#   end
#   neighbors.select { |neighbor| !path.include?(neighbor) }
# end

# def h point, path
#   (point[0] - @child[0]).abs + (point[1] - @child[1]).abs
# end

# def score_for_neighbor point, neighbor
#   1
# end

# def print_a_star curr_point, lowest, neighbors, set, from, g, f
#   return
# end

# puts a_star(start).last
