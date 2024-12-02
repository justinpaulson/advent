require '../../grid.rb'

def test_safe line
  nums = line.split(' ').map(&:to_i)
  diff = nums[0] - nums[1]
  direction = diff > 0 ? 1 : -1
  nums.each_cons(2) do |num1, num2|
    diff = num1 - num2
    test_dir = diff > 0 ? 1 : -1
    diff = diff.abs
    unless diff > 0 && diff < 4 && test_dir == direction
      return false
    end
  end
  return true
end

ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

total1 = 0
total2 = 0
lines.each do |line|
  if test_safe(line)
    total1 += 1
    total2 += 1
    next
  end
  line = line.split(' ')
  0.upto(line.length-1) do |i|
    test_line = line.dup
    test_line.delete_at(i)
    if test_safe(test_line.join(' '))
      total2 += 1
      break
    end
  end
end

puts total1
puts total2
