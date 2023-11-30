skips = IO.readlines("input").map(&:to_i)

nums = []
0.upto(255) do |i|
  nums << i
end

curr = 0
skip_size = 0
skips.each do |skip|
  rev_sub = nums[curr..curr+skip-1].reverse
  curr.upto(curr+skip-1) do |j|
    nums[j] = rev_sub[j-curr]
  end

  curr += skip + skip_size
  skip_size += 1
  curr = curr % nums.length
end

puts nums.to_s

# 26732 is too high