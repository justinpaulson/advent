require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

left = []
right = []
lines.each do |line|
  l, r = line.split('   ')
  left << l.to_i
  right << r.to_i
end

left.sort!
right.sort!

total = 0
left.each_with_index do |l, i|
  total += (l - right[i]).abs
end

puts total

total = 0
left.each do |l|
  total += right.sum{|r| r==l ? 1 : 0} * l
end

puts total
