require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

boxes = {}
lines.each do |line|
  x,y,z = line.split(",").map(&:to_i)
  boxes[[x,y,z]] = []
end

def all_pairs_by_distance(boxes)
  min_dist = Float::INFINITY
  distances = {}
  boxes.keys.combination(2) do |a, b|
    dist = Math.sqrt((a[0]-b[0])**2 + (a[1]-b[1])**2 + (a[2]-b[2])**2)
    distances[[a, b]] = dist
  end
  sorted = distances.sort_by { |_, dist| dist }
  sorted.map { |pair, _| pair }
end

def connect_boxes(boxes, a, b)
  boxes[a] << b
  boxes[b] << a
end

all_pairs = all_pairs_by_distance(boxes)
closest_pairs = all_pairs.first(1000)

closest_pairs.each do |a, b|
  connect_boxes(boxes, a, b)
end

def find_circuits(boxes)
  visited = {}
  circuits = []

  boxes.keys.each do |box|
    next if visited[box]

    circuit = []
    stack = [box]

    while stack.any?
      current = stack.pop
      next if visited[current]

      visited[current] = true
      circuit << current

      boxes[current].each do |neighbor|
        stack << neighbor unless visited[neighbor]
      end
    end

    circuits << circuit
  end

  circuits
end

product_of_sizes = find_circuits(boxes).sort_by { |c| -c.size }.first(3).map(&:size).reduce(1, :*)
puts product_of_sizes

all_pairs[1000..-1].each do |a, b|
  connect_boxes(boxes, a, b)
  if find_circuits(boxes).count == 1
    puts a[0] * b[0]
    break
  end
end
