require '../../grid.rb'
ARGV[0] ||= "input"
discs = IO.readlines(ARGV[0]).map(&:chomp).map{|line| line.split(" has ")[1].split(" positions; at time=0, it is at position ").map(&:to_i)}

puts discs.to_s

# part 2
discs << [11, 0]

goal = discs.map.with_index{|disc, i| [disc[0], (disc[0] - (i + 1)) % disc[0]]}

puts goal.to_s

t = 0
while discs != goal
  t += 1
  discs = discs.map{|disc| [disc[0], (disc[1] + 1) % disc[0]]}
end

puts t
