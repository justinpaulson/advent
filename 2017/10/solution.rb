require '../../grid.rb'

ARGV[0] ||= "input"

skips = IO.read(ARGV[0]).split(",").map(&:to_i)

nums = []
count = ARGV[0] == "input" ? 255 : 4
0.upto(count) do |i|
  nums << i
end

curr = 0
skip_size = 0
skips.each do |skip|
  nums.rotate!(curr)
  nums = nums[0..skip-1].reverse + nums[skip..-1] unless skip == 0
  nums.rotate!(-curr)

  curr += skip + skip_size
  skip_size += 1
  curr = curr % nums.length
end

puts nums[0] * nums[1]

0.upto(count) do |i|
  nums[i] = i
end

curr = 0
skip_size = 0
rounds = 0
skips =  skips.join(",").chars.map(&:ord)
skips += [17, 31, 73, 47, 23]
while rounds < 64
  skips.each_with_index do |skip, i|
    nums.rotate!(curr)
    nums = nums[0..skip-1].reverse + nums[skip..-1] unless skip == 0
    nums.rotate!(-curr)

    curr += skip + skip_size
    curr = curr % nums.length
    skip_size += 1
  end
  rounds += 1
end

nums.each_slice(16).map { |x| x.reduce(&:^) }.each do |x|
  print x.to_s(16).rjust(2,"0")
end
puts ""
