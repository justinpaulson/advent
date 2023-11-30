lines = IO.read("input").split("\n\n")

puts (lines.map do |line|
  line.split("\n").map(&:to_i).sum
end).max

puts (lines.map do |line|
  line.split("\n").map(&:to_i).sum
end).sort.reverse[0..2].sum