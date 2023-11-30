r=IO.read("input").split(',').map(&:to_i)
p (r.min..r.max).map{|n|r.map{|c|(1..(n-c).abs).sum}.sum}.min

# crabs = File.read("input").split(",").map(&:to_i)

# min = crabs.min
# max = crabs.max

# t1 = 999999999999999999
# t2 = 999999999999999999

# min.upto(max) do |i|
#   s1 = crabs.sum{|c| (c - i).abs }
#   t1 = s1 if s1 < t1
#   s2 = crabs.sum{|c| 1.upto((c - i).abs).sum }
#   t2 = s2 if s2 < t2
# end

# puts t1
# puts t2