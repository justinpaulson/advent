ARGV[0] ||= "input"
input = File.read(ARGV[0]).to_i

# get all divisors of a number
@divisors = {}
def divisors_of(number)
  return @divisors[number] if @divisors[number]
  divisors = []
  (1..Math.sqrt(number)).each do |i|
    if number % i == 0
      divisors << i
      divisors << number / i
    end
  end
  @divisors[number]=divisors.uniq
end

# slow
house = 0
total = 0
while total < input
  house += 1
  total = divisors_of(house).inject(:+) * 10
end

puts house

house = 0
total = 0
while total < input
  house += 1
  total = divisors_of(house).select { |d| house / d <= 50 }.inject(:+) * 11
end

puts house
