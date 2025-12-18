require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

points = lines.map { |line| line.split(',').map(&:to_i) }

max_rectangle = 0
points.permutation(2).each do |a, b|
  ractangle = (a[0] - b[0] + 1).abs * (a[1] - b[1] + 1).abs
  max_rectangle = [max_rectangle, ractangle].max
end

puts max_rectangle

def inside_polygon?(points, point)
  x, y = point
  inside = false
  # puts "Now checking #{point}"
  points.each_cons(2) do |a, b|
    x1, y1 = a
    x2, y2 = b
    if ((y1 > y) != (y2 > y)) && (x < (x2 - x1) * (y - y1) / (y2 - y1 + 0.0) + x1)
      # puts "Edge #{a}-#{b} crosses horizontal line at y=#{y}"
      inside = !inside
    end
  end
  # puts "#{point} is #{inside ? 'inside' : 'outside'} the polygon"
  inside
end

def eligible_rectangle(points, point_a, point_b)
  return false if point_a == point_b

  x1, y1 = point_a
  x2, y2 = point_b

  y1, y2 = [y1, y2].minmax

  points_to_check = []

  y1.upto(y2).each do |y|
    if y % 20 == 0
      points_to_check += [[x1, y], [x2, y]]
    end
  end

  points_to_check.each do |point|
    return false unless inside_polygon?(points, point)
  end

  true
end

max_rectangle = 0
points.combination(2).each do |a, b|
  x_min, x_max = [a[0], b[0]].minmax
  y_min, y_max = [a[1], b[1]].minmax
  rectangle = (x_max - x_min + 1) * (y_max - y_min + 1)
  next unless rectangle > max_rectangle
  next unless eligible_rectangle(points, a, b)
  max_rectangle = [max_rectangle, rectangle].max
end

puts max_rectangle
