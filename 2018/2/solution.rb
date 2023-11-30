lines = File.readlines("input")

def line_contains_twice line
  ret = false
  line.chars.each{|c| ret=true if line.count(c) == 2 }
  ret
end

def line_contains_thrice line
  ret = false
  line.chars.each{|c| ret=true if line.count(c) == 3 }
  ret
end

twice = 0
thrice = 0

lines.each do |line|
  line = line.chomp
  thrice += 1 if line_contains_thrice line
  twice += 1 if line_contains_twice line
end

puts twice * thrice

pairs = {}

lines[0..-2].each_with_index do |line_1, i|
  lines[i+1..-1].each do |line_2|
    pairs[[line_1,line_2]] = line_1.chars.each_with_index.select{|c, i| c == line_2[i]}.map{|a| a[0]}.join
  end
end

out = ""
pairs.values.each{|v| out = v if v.length > out.length}
puts out