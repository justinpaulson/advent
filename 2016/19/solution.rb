require '../../grid.rb'
ARGV[0] ||= "input"
input = File.read(ARGV[0]).strip

elves = (1..input.to_i).to_a

while elves.count > 3
  odd = elves.count.odd?
  elves = elves.each_slice(2).map(&:first)
  (elves.rotate!; elves.pop) if odd
end

puts elves.first

elves = (1..input.to_i).to_a

while elves.count > 1
  elves.delete_at(elves.count / 2)
  elves.rotate!
end

puts elves.first
