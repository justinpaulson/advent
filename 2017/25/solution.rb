require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

cursor = 50000
tape = Array.new(100000, 0)
state = nil
steps = nil

states = {}

current_state = nil
current_value = nil
lines.each do |line|
  if line[0..14] == "Begin in state "
    state = line[15]
  elsif line[0..35] == "Perform a diagnostic checksum after "
    steps = line[36..-7].to_i
  elsif line[0..8] == "In state "
    current_state = line[9]
    states[current_state] ||= {}
  elsif line[0..25] == "  If the current value is "
    current_value = line[26].to_i
    states[current_state][current_value] = {}
  elsif line[0..21] == "    - Write the value "
    states[current_state][current_value][:write] = line[22].to_i
  elsif line[0..26] == "    - Move one slot to the "
    states[current_state][current_value][:move] = line[27] == "r" ? 1 : -1
  elsif line[0..25] == "    - Continue with state "
    states[current_state][current_value][:continue] = line[26]
  end
end

while steps > 0
  steps -= 1
  value = tape[cursor]
  tape[cursor] = states[state][value][:write]
  cursor += states[state][value][:move]
  state = states[state][value][:continue]
end

puts tape.sum
