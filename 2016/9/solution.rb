line = IO.read("input").chomp


def length_of_string s
  return s.length unless s.match?(/\)/)
  eq = s.split(")")[0]
  skip_length = eq.length
  eq = eq[1..-1]
  length, repeat = eq.split("x").map(&:to_i)
  remainder_s = s.split(")")[1..-1].join(")")[length..-1]
  s = s[skip_length+1..length+skip_length]
  repeat * length_of_string(s) + length_of_string(remainder_s)
end

puts length_of_string line