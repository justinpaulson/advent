ARGV[0] ||= "input"
lines = File.readlines(ARGV[0])

code_total = 0
memory_total = 0
encode_total = 0

def mem_total line
  line = line[1..-2]
  line = line.gsub("\\\"", "'")
  line = line.gsub("\\\\", ".")
  line = line.gsub(/\\x[a-f0-9]{2}/, ".")
  line.length
end

def enc_total line
  line = line.gsub("\\", "\\\\\\\\")
  line = line.gsub("\"", "\\\"")
  line = "\"" + line + "\""
  line.length
end

lines.each do |line|
  line = line.chomp
  code_total += line.length
  memory_total += mem_total line
  encode_total += enc_total line
end

ans=code_total - memory_total

puts ans

ans2 = encode_total - code_total

puts ans2
