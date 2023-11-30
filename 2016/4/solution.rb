lines = File.readlines("input")

def valid room
  checksum = room.split('[').last.split(']').first
  code = room.split('-')[0..-2].join
  char_map = {}
  code.chars.each{|c| char_map[c] ||= 0; char_map[c] +=1}
  x = char_map.sort_by{|k, v| [-v, k]}
  x[0..4].map{|a| a[0]}.join == checksum
end

t = 0

lines.each{|l| t+=l.split("-").last.split("[").first.to_i if valid l}

puts t

lines.each do |l|
  shift = l.split("-").last.split("[").first.to_i
  shift = shift % 26
  new_l = l.chars.map{|c| c.match?(/[a-z]/) ? ((c.ord + shift) > 122 ? (c.ord + shift - 26) : (c.ord + shift)).chr : (c == "-" ? " " : c) }.join
  puts new_l if new_l.match?(/north/)
end