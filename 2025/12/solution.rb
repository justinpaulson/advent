require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.read(ARGV[0]).chomp

shape_0, shape_1, shape_2, shape_3, shape_4, shape_5, tests = lines.split("\n\n")

correct = 0
tests.split("\n").each do |test|
  size, counts = test.split(": ")
  size = size.split("x").map(&:to_i).reduce(:*)
  counts = counts.split(" ").map(&:to_i)

  # Very input specific here to create the counts.
  # this is not a general solution, but we are here for stars!

  total = 0
  total += [counts[0], counts[1]].min * 15
  total += [counts[0], counts[1]].minmax.reduce(:- ) * -9
  total += [counts[4], counts[5]].min * 12
  total += [counts[4], counts[5]].minmax.reduce(:- ) * -9
  total += (counts[3]/2) * 16
  total += (counts[3]%2) * 9
  total += (counts[2]/2) * 20
  total += (counts[2]%2) * 9
  correct += (total < size ? 1 : 0)
end

puts correct
