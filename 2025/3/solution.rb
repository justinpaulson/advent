require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

total_output = 0
total_2_output = 0
lines.each do |line|

  max_battery = line.chars.map(&:to_i).max
  index = line.chars.index(max_battery.to_s)

  if index == line.length - 1
    max_battery = line[0..-2].chars.map(&:to_i).max
    index = line[0..-2].chars.index(max_battery.to_s)
  end

  nex_max = line[index+1..-1].chars.map(&:to_i).max

  total_output += max_battery * 10 + nex_max

  winner = ""
  max = line[0..-12].chars.map(&:to_i).max
  max_index = line.chars.index(max.to_s)
  winner += max.to_s
  1.upto(11) do |i|
    next_max = line[(max_index + 1)..(-12+i)].chars.map(&:to_i).max
    max_index = line[(max_index + 1)..(-12+i)].chars.index(next_max.to_s) + max_index + 1
    winner += next_max.to_s
  end
  max = winner.to_i

  total_2_output += max
end

puts total_output
puts total_2_output
