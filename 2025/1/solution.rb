require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
g = Grid.new(lines)

dial = 50
start_dial = dial
total1 = 0
total = 0
lines.each do |line|
  if line[0] == "R"
    moves = line[1..-1].to_i
    total += moves / 100
    dial += moves % 100
  else
    moves = line[1..-1].to_i
    total += moves / 100
    dial -= moves % 100
  end
  if dial > 99
    dial = dial - 100
    unless dial == 0 || start_dial == 0
      total += 1
    end
  end
  if dial < 0
    dial = 99 + dial + 1
    unless dial == 0 || start_dial == 0
      total += 1
    end
  end
  if dial == 0
    total += 1
    total1 += 1
  end
  start_dial = dial
end

puts total1
puts total
