lines = File.readlines("input").map(&:to_i)

t = 0
lines.each_with_index do |line, i|
  t += 1 if lines[i+1] && line < lines[i+1]
end
puts t

init_cursor = [0,1,2]

new_lines = []

0.upto(lines.length-3) do |i|
  cursor = init_cursor.map{|a| a+i}
  new_lines << [lines[cursor[0]],lines[cursor[1]],lines[cursor[2]]].sum
end

t = 0
new_lines.each_with_index do |line, i|
  t += 1 if new_lines[i+1] && line < new_lines[i+1]
end

puts t