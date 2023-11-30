lines = File.readlines("input").map(&:chomp)

gamma = ""
ep =""

new_lines = []

lines.each do |line|
  0.upto(line.length-1) do |i|
    new_lines[i] ||= ""
    new_lines[i] += line[i]
  end
end

lines = new_lines

0.upto(lines.length-1) do |i|
  gamma += lines[i].count("0") > lines[i].count("1") ? "0" : "1"
  ep += lines[i].count("0") < lines[i].count("1") ? "0" : "1"
end

puts ep.to_i(2) * gamma.to_i(2)

puts ep.to_i(2)
puts ep
puts gamma.to_i(2)
puts gamma

lines = File.readlines("input").map(&:chomp)

o2 = lines.clone
co2 = lines.clone

len = lines[0].length
0.upto(len-1) do |cursor|
  if o2.length > 1
    o2_char = o2.sum{|l| l[cursor] == "1" ? 1 : 0} >= o2.sum{|l| l[cursor] == "0" ? 1 : 0} ? "1" : "0"
    o2 = o2.select{|l| l[cursor] == o2_char}
  end
  if co2.length > 1
    co2_char = co2.sum{|l| l[cursor] == "1" ? 1 : 0} >= co2.sum{|l| l[cursor] == "0" ? 1 : 0} ? "0" : "1"
    co2 = co2.select{|l| l[cursor] == co2_char}
  end
end

puts o2
puts o2[0].to_i(2)
puts co2
puts co2[0].to_i(2)


puts o2[0].to_i(2) * co2[0].to_i(2)
