require '../../grid.rb'
ARGV[0] ||= "input"
input = IO.read(ARGV[0]).chomp

def knot_hash key
  nums = []
  0.upto(255) do |i|
    nums[i] = i
  end
  curr = 0
  skip_size = 0
  rounds = 0
  skips =  key.chars.map(&:ord)
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

  knot_hash = ""
  nums.each_slice(16).map { |x| x.reduce(&:^) }.each do |x|
    knot_hash += x.to_s(16).rjust(2,"0")
  end
  knot_hash
end

@grid = new_grid(128,128)
used = []
0.upto(127) do |i|
  key = input + "-#{i}"
  hash = knot_hash(key)
  binary = hash.to_i(16).to_s(2)
  binary = binary.rjust(128,"0")
  binary.chars.each_with_index do |char, j|
    if char == "1"
      @grid[i][j] = "#"
      used << [i,j]
    else
      @grid[i][j] = "."
    end
  end
end

puts used.count

def get_neighbors point
  neighbors = []
  neighbors << [point[0]-1, point[1]] if point[0] > 0
  neighbors << [point[0]+1, point[1]] if point[0] < 127
  neighbors << [point[0], point[1]-1] if point[1] > 0
  neighbors << [point[0], point[1]+1] if point[1] < 127
  neighbors.select { |neighbor| @grid[neighbor[0]][neighbor[1]] == "#" }
end

all_used = used.clone
seen = Set.new

total = 0
while (@goal = all_used.shift)
  total += 1

  queue = get_neighbors(@goal).select { |neighbor| !seen.include?(neighbor) }
  while (point = queue.shift)
    next if point == @goal
    seen << point
    queue += get_neighbors(point).select { |neighbor| !seen.include?(neighbor) }
  end
  all_used -= seen.to_a
end

puts total
