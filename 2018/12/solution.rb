require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
state = lines.shift.split(": ")[1]
lines.shift

rules = {}
lines.each do |line|
  key, val = line.split(" => ")
  rules[key] = val
end

state = "."*10 + state + "...."
20.times do
  new_state = state.dup
  0.upto(state.length - 5) do |i|
    new_state[i+2] = rules[state[i,5]] || "."
  end
  state = new_state
  state += ".." if state[-5..-1].include?("#")
end

puts (state.chars.each_with_index.map do |c, i|
  c == "#" ? i - 10 : 0
end).sum

cycles = 0
rotates = 10
states = {}
cycles = []
i = 20
while (i += 1)
  new_state = state.dup
  0.upto(state.length - 5) do |i|
    new_state[i+2] = rules[state[i,5]] || "."
  end
  state = new_state
  state += ".." if state[-4..-1].include?("#")
  if state[0..9] == ".........."
    state = state[5..-1]
    rotates -= 5
  end
  states[state] ||= 0
  states[state] += 1
  if states[state] == 2
    cycles << [state, i, rotates]
  end
  break if states[state] == 3
end

num_cycles = (50000000000 - cycles.map{|a| a[1]}.max) / cycles.count + 3
index = (50000000000-cycles.map{|a| a[1]}.max - 1) % cycles.count

state = cycles[index][0]
rotates = num_cycles * 10
puts (state.chars.each_with_index.map do |c, i|
  c == "#" ? i + rotates : 0
end).sum
