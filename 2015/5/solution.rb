ARGV[0] ||= "input"
lines = File.readlines(ARGV[0]).map(&:chomp)

nice_1_regex = /([aeiou].*){3,}/
nice_1a_regex = /([a-z])\1/
bad_strings = %w(ab cd pq xy)
nice_2_regex = /([a-z]{2}).*\1/
nice_2a_regex = /([a-z]{1})[a-z]{1}\1/
ans=0
ans2=0
lines.each do |line|
  ans += 1 if line.match?(nice_1_regex) && line.match?(nice_1a_regex) && !line.match?(/#{bad_strings.join("|")}/)
  ans2 += 1 if line.match?(nice_2_regex) && line.match?(nice_2a_regex)
end
puts ans
puts ans2
