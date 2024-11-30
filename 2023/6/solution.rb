time = [ 46, 68, 98, 66 ]
distance = [ 358, 1054, 1807, 1080 ]

# time = [ 7, 15, 30 ]
# distance = [ 9, 40, 200 ]

options = []

time.each_with_index do |t, i|
  d = distance[i]
  options[i] ||= 0
  (0..t).each do |holds|
    traveled = (t - holds) * holds
    if traveled > d
      puts "t: #{ t } holds: #{ holds } traveled: #{ traveled } d: #{ d }"
      options[i] += 1
    end
  end
end
puts options.to_s
puts options[0] * options[1] * options[2] * options[3]

time = 46689866
distance = 358105418071080
total = 0
(0..time).each do |holds|
  traveled = (time - holds) * holds
  if traveled > distance
    total += 1
  end
end
puts total




# too high
# 194481
