exps = File.readlines("input").map{|l|l.split.map(&:to_i)}

def can_triangle?(sides)
  !(sides[0] + sides[1] <= sides[2] ||
    sides[1] + sides[2] <= sides[0] ||
    sides[0] + sides[2] <= sides[1])
end


t = 0
exps.each do |sides|
  t+=1 if can_triangle?(sides)
end

puts t

t = 0
exps.each_slice(3) do |a, b, c|
  t+=1 if can_triangle?([a[0], b[0], c[0]])
  t+=1 if can_triangle?([a[1], b[1], c[1]])
  t+=1 if can_triangle?([a[2], b[2], c[2]])
end

puts t
