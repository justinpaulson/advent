ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

distances = {}

lines.each do |line|
  cities, distance = line.split(" = ")
  distance = distance.to_i
  cities = cities.split(" to ")
  distances[cities[0]] ||= {}
  distances[cities[0]][cities[1]] = distance
  distances[cities[1]] ||= {}
  distances[cities[1]][cities[0]] = distance
end

longest = 0
shortest = 99999999
distances.keys.permutation.each do |perm|
  distance = 0
  perm.each_with_index do |city, i|
    if i < perm.length - 1
      distance += distances[city][perm[i+1]]
    end
  end
  longest = distance if distance > longest
  shortest = distance if distance < shortest
end

puts shortest
puts longest
