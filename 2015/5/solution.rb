lines = File.readlines("input")

nice_1_regex = /([a-z]{2}).*\1/
nice_2_regex = /([a-z]{1})[a-z]{1}\1/

ans=0

lines.each do |line|
  ans += 1 if line.match?(nice_1_regex) && line.match?(nice_2_regex)
end

puts ans