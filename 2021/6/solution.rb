input = File.read("input").chomp.split(",").map(&:to_i)
fish = []
0.upto(8) do |i|
  fish[i] = input.count(i)
end

0.upto(79) do |i|
  new_fish = []
  new_fish[8] = fish[0]
  new_fish[7] = fish[8]
  new_fish[6] = fish[7]
  new_fish[6] += fish[0]
  new_fish[5] = fish[6]
  new_fish[4] = fish[5]
  new_fish[3] = fish[4]
  new_fish[2] = fish[3]
  new_fish[1] = fish[2]
  new_fish[0] = fish[1]
  fish = new_fish.clone
end

p fish.sum

0.upto(255) do |i|
  new_fish = []
  new_fish[8] = fish[0]
  new_fish[7] = fish[8]
  new_fish[6] = fish[7]
  new_fish[6] += fish[0]
  new_fish[5] = fish[6]
  new_fish[4] = fish[5]
  new_fish[3] = fish[4]
  new_fish[2] = fish[3]
  new_fish[1] = fish[2]
  new_fish[0] = fish[1]
  fish = new_fish.clone
end

p fish.sum