require '../../grid.rb'
ARGV[0] ||= "input"
stones = IO.readlines(ARGV[0]).map(&:chomp).map do |line|
  position, velocity = line.split(" @ ").map{|s| s.split(",")}.map{|s| s.map(&:to_i)}
end

test_max = 27
test_min = 7

max = 400000000000000
min = 200000000000000

if ARGV[0] == "test"
  max = test_max
  min = test_min
end


# respond with true if the position is in the future based on current stone position
# respond with false if the position is in the past based on current stone position
def later stone, x
  # puts stone
  # puts x
  result = stone[1][0] > 0 ? x > stone[0][0] : x < stone[0][0]
  # puts result
  result
end


checked = []

collisions = {}

puts "what?"
puts stones.length

count = 0
stones.each do |stone|
  count += 1
  puts count
  stones.each do |other_stone|
    next if stone == other_stone
    next if checked.include?([other_stone, stone]) || checked.include?([stone, other_stone])

    slope_stone = stone[1][1].to_f / stone[1][0]
    slope_other_stone = other_stone[1][1].to_f / other_stone[1][0]

    intercept_stone = stone[0][1] - slope_stone * stone[0][0]
    intercept_other_stone = other_stone[0][1] - slope_other_stone * other_stone[0][0]

    x = (intercept_other_stone - intercept_stone) / (slope_stone - slope_other_stone)

    y = slope_stone * x + intercept_stone

    unless later(stone, x) && later(other_stone, x)
      checked << [stone, other_stone]
      next
    end

    if x >=min && x <= max && y >= min && y <= max && slope_stone != slope_other_stone
      collisions[[stone, other_stone]] ||= 0
      collisions[[stone, other_stone]] += 1
      checked << [stone, other_stone]
      next
    end


    checked << [stone, other_stone]
  end
end

puts collisions.to_s

puts collisions.keys.count
