lines = File.read("input")

# lines = "0 2 7 0"

def redist banks
  index = banks.index(banks.max)
  cursor = (index + 1) % banks.length
  t = banks.max
  banks[index] = 0
  while t > 0
    banks[cursor] += 1
    cursor += 1
    cursor = cursor % banks.length
    t -= 1
    # puts banks.to_s
    # sleep 1
  end
  banks
end

banks = lines.split.map(&:to_i)

scenarios = {banks.to_s => 1}
t = 1
while true
  next_scenario = redist banks
  (puts t; repeat = next_scenario; break) if scenarios[next_scenario.to_s]
  scenarios[next_scenario.to_s] = 1
  banks = next_scenario
  t += 1
end

banks = repeat.clone

t = 1
while true
  next_scenario = redist banks
  (puts t; return) if next_scenario.to_s == repeat.to_s
  banks = next_scenario
  t += 1
end

