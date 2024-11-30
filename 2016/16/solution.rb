require '../../grid.rb'
ARGV[0] ||= "input"

input = File.read(ARGV[0]).strip

disc_length = 272

while input.length < disc_length
  input = input + "0" + input.reverse.tr('01', '10')
end

input = input[0...disc_length]

while input.length % 2 == 0
  input = input.chars.each_slice(2).map { |a,b| a == b ? "1" : "0" }.join
end

puts input


disc_length = 35651584

input = File.read(ARGV[0]).strip


while input.length < disc_length
  input = input + "0" + input.reverse.tr('01', '10')
end

input = input[0...disc_length]

while input.length % 2 == 0
  input = input.chars.each_slice(2).map { |a,b| a == b ? "1" : "0" }.join
end

puts input
