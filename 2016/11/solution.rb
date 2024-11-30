# lines = IO.readlines("input")

require 'set'

require '../../grid.rb'

# The first floor contains a strontium generator, a strontium-compatible microchip, a plutonium generator, and a plutonium-compatible microchip.
# The second floor contains a thulium generator, a ruthenium generator, a ruthenium-compatible microchip, a curium generator, and a curium-compatible microchip.
# The third floor contains a thulium-compatible microchip.
# The fourth floor contains nothing relevant.

# s r t p c

#
# tm
# tg, rg, rm, cg, cm
# sm, sg, pm, pg

def no_conflicts floors
  floors.each do |floor|
    chips = floor & ["tm","sm","cm","pm","rm","hm","lm","dm","em"].to_set
    gens = floor & ["tg","sg","cg","pg","rg","hg","lg","dg","eg"].to_set
    safe_chips = gens.map{|g| "#{g[0]}m"}
    chips -= safe_chips
    return false unless chips.empty? || gens.empty?
  end
  true
end

@legal_moves = {}
def legal_moves location
  return @legal_moves[location] if @legal_moves[location]
  e, floors = location
  items = floors[e]
  moves = []
  items.to_a.combination(2).each do |i1,i2|
    ([e+1]-[-1,4]).each do |floor|
      next if floor == 0 && floors[0].empty?
      next if floor == 1 && floors[1].empty? && floors[0].empty?
      new_floors = deep_copy floors
      new_floors[e] = new_floors[e] - [i1,i2]
      new_floors[floor].merge([i1, i2])
      moves << [floor, new_floors] if no_conflicts(new_floors)
    end
  end
  items.each do |i1|
    ([e+1,e-1]-[-1,4]).each do |floor|
      next if floor == 0 && floors[0].empty?
      next if floor == 1 && floors[1].empty? && floors[0].empty?
      new_floors = deep_copy floors
      new_floors[e] = new_floors[e] - [i1]
      new_floors[floor].add(i1)
      moves << [floor, new_floors] if no_conflicts(new_floors)
    end
  end
  @legal_moves[location] = deep_copy(moves)
  @legal_moves[location]
end

def is_goal? location
  if ARGV[0] == "test"
    return location == [3, [[].to_set, [].to_set, [].to_set, ["hm","lm","hg","lg"].to_set]]
  end
  location == [3, [[].to_set, [].to_set, [].to_set, ["sm","sg","pg","pm","tg","tm","rg","rm","cg","cm","eg","em","dg","dm"].to_set]]
end

def score_for_neighbor location, neighbor
  1
end

def get_neighbors location, path
  legal_moves(deep_copy(location)).select{|m| !path.include?(m)}
end

@h = {}
def h location
  0
  # return @h[location] if @h[location]
  # elevator, floors = location
  # @h[location] = floors.reverse.each_with_index.map do |floor, i|
  #   floor.count * (i + 5)
  # end.sum
end

@currents = {}
def print_a_star curr_point, lowest, neighbors, set, from, g, f
  @currents[curr_point] ||= 0
  @currents[curr_point] += 1
  if @currents[curr_point] > 1
    puts "Current point is repeated: #{curr_point}, #{@currents[curr_point]}"
  else
    puts @currents.count
  end
  # puts "Lowest Score: #{lowest}, Set count: #{set.length}, Current Point: #{curr_point}"
  # key_wait
  return
  puts "Current Point: #{curr_point}"
  puts "Neighbors: #{neighbors}"
  puts "Set: #{set}"
  puts "From: #{from}"
  puts "G: #{g}"
  puts "F: #{f}"
end

# part 1
# floors = [
#   ["sm", "sg", "pm", "pg"].to_set,
#   ["tg", "rg", "rm", "cg", "cm"].to_set,
#   ["tm"].to_set,
#   [].to_set
# ]
# elevator = 0

# part 2
floors = [
  ["sm", "sg", "pm", "pg", "eg", "em", "dg", "dm"].to_set,
  ["tg", "rg", "rm", "cg", "cm"].to_set,
  ["tm"].to_set,
  [].to_set
]
elevator = 0

if ARGV[0] == "test"
  floors = [
    ["hm", "lm"].to_set,
    ["hg"].to_set,
    ["lg"].to_set,
    [].to_set
  ]
end

@queue = [[elevator, floors, 0]]
@visited = {}
while @queue.length > 0
  elevator, floors, steps = @queue.shift
  next if @visited[[elevator, floors]] && @visited[[elevator, floors]] <= steps
  @visited[[elevator, floors]] = steps
  puts "#{@visited.count} #{steps} #{@queue.length}" if @visited.count % 1000 == 0
  if is_goal?([elevator, floors])
    # puts "Found goal!"
    # puts floors
    # puts elevator
    # puts @queue.length
    puts steps
    break
  end
  legal_moves([elevator, floors]).each do |move|
    @queue << move + [steps + 1]
  end
end
# part_1 = a_star([elevator, floors])

# puts part_1.last

# wrong
# 65

# right
# 61
