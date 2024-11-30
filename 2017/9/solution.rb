ARGV[0] ||= "input"

s = File.read(ARGV[0]).chomp.gsub(/!.{1}/,"").gsub(/<[^>]*>/,"")

level = 1
cursor = 0
char = s[cursor]
total = 0
while level > 0 && cursor < s.length - 1
  cursor += 1
  char = s[cursor]
  if char == "{"
    level += 1
  elsif char == "}"
    total += level
    level -= 1
  end
end

puts total

s = File.read(ARGV[0]).chomp.gsub(/!.{1}/,"")

part_2 = s.scan(/<[^>]*>/).map{|x| x.length - 2}.reduce(:+)

puts part_2
