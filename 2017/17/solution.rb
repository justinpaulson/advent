require '../../grid.rb'
ARGV[0] ||= "input"
input = IO.read(ARGV[0]).chomp.to_i

values = []

current = 0
cursor = 0
while current < 2018
  cursor = (cursor + input) % values.length if values.length > 0
  cursor += 1 if values.length > 0
  values.insert(cursor, current)
  current += 1
end

puts values[cursor+1]

current = 0
cursor = 0
after_zero = nil
while current < 50000001
  cursor = (cursor + input) % current if current > 0
  cursor += 1 if current > 0
  after_zero = current if cursor == 1
  current += 1
end

puts after_zero
