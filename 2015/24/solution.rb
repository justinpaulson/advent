require '../../grid.rb'
ARGV[0] ||= "input"
@packages = IO.readlines(ARGV[0]).map(&:chomp).map(&:to_i)

puts @packages.to_s
puts @packages.sum
puts @packages.sum / 4

# part 1
# group1 = [113, 109, 107, 103, 79, 1]
# group2 = [2, 101, 97, 89, 83, 73, 67]
# @packages = @packages - group1
# @packages = @packages - group2

# group3 = @packages

# part 2
# group1 = [103, 101, 97, 83]
# group2 = [113, 109, 107, 53, 2]
# group3 = [89, 79, 73, 71, 67, 5]
# @packages = @packages - group1
# @packages = @packages - group2
# @packages = @packages - group3

# group4 = @packages

# puts group1.to_s
# puts group1.sum
# puts group2.to_s
# puts group2.sum
# puts group3.to_s
# puts group3.sum
# puts group4.to_s
# puts group4.sum

@packages.sort!.reverse!

# while group1.sum < split
#   group1 << packages.shift
# end

# puts group1.to_s
# puts group1.sum

# while group1.sum != split
#   diff = group1.sum - split
#   puts diff
#   we_done = false
#   group1.each do |p1|
#     next if we_done
#     packages.each do |p2|
#       next if we_done
#       if p1 - p2 == diff
#         puts "Found a match! #{p1} - #{p2} = #{diff}"
#         group1.delete(p1)
#         group1 << p2
#         packages.delete(p2)
#         packages << p1
#         we_done = true
#       end
#     end
#   end
#   unless we_done

#   end
# end



def is_goal? point
  puts "#{point} #{point.sum}"
  point.sum == 384
end

def score_for_neighbor point, neighbor
  1
end

def h point
  384 - point.sum
end

def print_a_star curr_point, lowest, neighbors, set, from, g, f
  return
end

def get_neighbors point, path
  neighbors = []
  @packages.each do |pack|
    next if point.include?(pack)
    next if pack + point.sum > 384
    neighbors << (point + [pack])
  end
  neighbors
end

start = [103]

puts a_star(start).to_s
# puts group1.inject(:*)
