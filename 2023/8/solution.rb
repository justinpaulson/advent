lines = IO.readlines("input")

turns = "LLRLLRLRLRRRLLRRRLRRLRLRLRLRLRLRRLRRRLRLLRRLRRLRRRLLRLLRRLLRRRLLLRLRRRLLLLRRRLLRRRLRRLRLLRLRLRRRLRRRLRRLRRLRRLRLLRRRLRRLRRRLLRRRLRLRRLLRRLLRLRLRRLRRLLRLLRRLRLLRRRLLRRRLRRLLRRLRRRLRLRRRLRRLLLRLLRLLRRRLRLRLRLRRLRRRLLLRRRLRRRLRRRLRRLRLRLRLRRRLRRLLRLRRRLRLRLRRLLLRRRR"

nodes = {}

lines.each do |line|
  parts = line.chomp.split(" = ")
  nodes[parts[0]] = parts[1].delete("(").delete(")").split(", ")
end

node = "AAA"

turn = 0

total = 0

while(node != "ZZZ")
  node = nodes[node][turns[turn] == "L" ? 0 : 1]
  total += 1
  turn += 1
  turn = turn % turns.length
end

puts total

starts = nodes.keys.select { |k| k[2] == "A" }

turn = 0
cycles = []
starts = starts.map do |start|
  node = start
  moves = 0
  while(node[2] != "Z")
    node = nodes[node][turns[turn] == "L" ? 0 : 1]
    moves += 1
    turn += 1
    turn = turn % turns.length
  end
  cycles << moves
end

# least common multiple of all cycles
puts cycles.reduce(1, :lcm)
