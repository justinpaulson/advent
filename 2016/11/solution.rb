lines = IO.readlines("input")

require 'set'

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
    chips = floor & ["tm","sm","cm","pm","rm"].to_set
    gens = floor & ["tg","sg","cg","pg","rg"].to_set
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
    ([e+1,e-1]-[-1,4]).each do |floor|
      new_floors = floors.clone
      new_floors[e] = new_floors[e] - [i1,i2]
      new_floors[floor].merge([i1, i2])
      moves << [floor, new_floors] if no_conflicts(new_floors)
    end
  end
  items.each do |i1|
    ([e+1,e-1]-[-1,4]).each do |floor|
      new_floors = floors.clone
      new_floors[e] = new_floors[e] - [i1]
      new_floors[floor].add(i1)
      moves << [floor, new_floors] if no_conflicts(new_floors)
    end
  end
  @legal_moves[location] = moves
  @legal_moves[location]
end

def lowest_score scores, locations
  low = [[[],[],[],[]], 9999]
  locations.each do |score, loc|
    low = [loc,scores[loc]] if scores[loc] < low[1]
  end

  low
end

def reconstruct_path from, current
  total_path = [current]
  while from.keys.include?(current)
    current = from[current]
    total_path.prepend(current)
  end
  total_path
end

def h location
  elevator, floors = location
  floors.each_with_index.map do |floor, i|
    floor.count * (i + 1)
  end.sum
end

def a_star start, goal
  set = [[0,start]]
  from = {}
  g = {}
  g[start] = 0

  f = {}
  f[start] = h(start)
  puts start.to_s

  while set.count > 0
    curr_location, curr_low = lowest_score f, set
    puts curr_location.to_s
    puts curr_low
    return [reconstruct_path(from,[curr_location]), g[curr_location]] if curr_location == goal
    
    set -= [curr_location]

    moves = legal_moves(curr_location)

    moves.each do |loc|
      tent_g = (g[curr_location] || 0) + 1
      g[loc] ||= 999999
      puts g[loc]
      puts tent_g
      if tent_g < g[loc]
        from[loc] = curr_location
        g[loc] = tent_g
        f[loc] = tent_g + h(loc)
        set += [loc]
      end
    end
    # puts set.to_s

    # print_grid g, ","
    # sleep 0.01
  end

  return false
end

floors = [
  ["sm", "sg", "pm", "pg"].to_set,
  ["tg", "rg", "rm", "cg", "cm"].to_set,
  ["tm"].to_set,
  [].to_set
]
elevator = 0

goal = [
  [].to_set,
  [].to_set,
  [].to_set,
  ["sm","sg","pg","pm","tg","tm","rg","rm","cg","cm"].to_set
]

part_1 = a_star([elevator, floors], [3, goal])

p part_1.to_s