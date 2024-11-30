require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp).map{|l| l.split(" ")[-1]}.map(&:to_i)

factor_a = 16807
factor_b = 48271

mod = 2147483647

total = 0
40000000.times do |i|
  lines[0] = (lines[0] * factor_a) % mod
  lines[1] = (lines[1] * factor_b) % mod
  if lines[0].to_s(2)[-16..-1] == lines[1].to_s(2)[-16..-1]
    total += 1
  end
end

puts total

lines = IO.readlines(ARGV[0]).map(&:chomp).map{|l| l.split(" ")[-1]}.map(&:to_i)
total = 0
5000000.times do |i|
  lines[0] = (lines[0] * factor_a) % mod
  lines[0] = (lines[0] * factor_a) % mod while lines[0] % 4 != 0
  lines[1] = (lines[1] * factor_b) % mod
  lines[1] = (lines[1] * factor_b) % mod while lines[1] % 8 != 0
  if lines[0].to_s(2)[-16..-1] == lines[1].to_s(2)[-16..-1]
    total += 1
  end
end

puts total
