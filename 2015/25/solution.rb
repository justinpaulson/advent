require '../../grid.rb'

# row 2947, column 3029.

first_code = 20151125
multiplier = 252533
mod = 33554393

row = 2947
column = 3029

# row = 6
# column = 5

total = 1
(row-1).downto(1) do |c|
  total += c
end

puts total

(2).upto(column) do |i|
  total += row + i - 1
  puts total
end

start = first_code
(total-1).times do
  start = (start * multiplier) % mod
end

puts start



#too low
# 2662772

# too high
# 22744693
