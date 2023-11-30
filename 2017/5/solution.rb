instructions = File.readlines("input").map(&:to_i)
cursor = 0
steps = 0

while cursor >= 0 && cursor < instructions.length
  steps += 1
  move = instructions[cursor]
  instructions[cursor] += 1
  cursor += move
end

puts steps

instructions = File.readlines("input").map(&:to_i)
cursor = 0
steps = 0

while cursor >= 0 && cursor < instructions.length
  steps += 1
  move = instructions[cursor]
  instructions[cursor] += instructions[cursor] >= 3 ? -1 : 1
  cursor += move
end

puts steps