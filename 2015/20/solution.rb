input = 33100000

# get all divisors of a number
def divisors_of(number)
  divisors = []
  (1..Math.sqrt(number)).each do |i|
    if number % i == 0
      divisors << i
      divisors << number / i
    end
  end
  divisors.uniq
end

# part 1
# house = 0
# total = 0
# while total < input
#   house += 1
#   total = divisors_of(house).inject(:+) * 10
# end

# puts house

# part 2
house = 0
total = 0
while total < input
  puts house if house % 10000 == 0
  house += 1
  total = divisors_of(house).select { |d| house / d <= 50 }.inject(:+) * 11
end

puts house
