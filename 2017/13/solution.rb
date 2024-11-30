require '../../grid.rb'
ARGV[0] ||= "input"
traps = IO.readlines(ARGV[0]).map(&:chomp).map{|t| t.split(": ").map(&:to_i)}

total = 0

traps.each do |(interval, mod)|
  total += (interval * mod) if interval % (mod * 2 - 2) == 0
end

puts total

delay = 0
while total > 0
  total = 0
  delay += 1
  traps.each do |(interval, mod)|
    total += 1 if (interval + delay) % (mod * 2 - 2) == 0
  end
end

puts delay
