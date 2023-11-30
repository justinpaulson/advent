lines = File.readlines("input")


def support_tls line
  split_line = line.split("[")

  code = split_line[0]
  hype = ""
  split_line[1..-1].each{|sp| h,c = sp.split("]"); code += " #{c}"; hype += " #{h}"}
  reg = /([a-z]{1})(?!\1)([a-z^\1])\2\1/
  return code.match?(reg) && !hype.match?(reg)
end

def support_ssl line
  split_line = line.chomp.split("[")

  code = split_line[0]
  hype = ""
  split_line[1..-1].each{|sp| h,c = sp.split("]"); code += " #{c}"; hype += " #{h}"}
  
  puts "#{code}[#{hype}]"

  if "#{code}[#{hype}]".match?(/([a-z]{1})(?!\1)([a-z^\1])\1.*\[.*\2\1\2.*\]/)
    puts line
    true
  else
    false
  end
end


ans=0
ans2=0
lines.each do |line|
  ans += 1 if support_tls(line)
  ans2 += 1 if support_ssl(line)
end
puts ans
puts ans2


# 208
# 282