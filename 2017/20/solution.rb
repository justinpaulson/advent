require '../../grid.rb'
ARGV[0] ||= "input"
buffer = IO.readlines(ARGV[0]).map(&:chomp).map do |line|
  line.split(", ").map do |a|
    a.split("<")[1].split(">").first.split(",").map(&:to_i)
  end.flatten
end

target = [0,0,0]

puts buffer.index(buffer.sort_by do |particle|
  particle[6..8].map(&:abs).sum
end.first)

time = 0
while time < 1000
  time += 1
  buffer = buffer.map do |particle|
    particle[3..5] = particle[3..5].zip(particle[6..8]).map(&:sum)
    particle[0..2] = particle[0..2].zip(particle[3..5]).map(&:sum)
    particle
  end
  buffer = buffer.group_by{|particle| particle[0..2]}.select{|k,v| v.length == 1}.values.map(&:flatten)
end

puts buffer.count
