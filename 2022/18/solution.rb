lines = IO.readlines("input").map{|l| l.split(",").map(&:to_i)}

@contained = []

require '../../grid'

def gap_contained? gap, gaps, blocks, steps
  # puts ((gap[0]-10)**2+(gap[1]-10).abs**2+(gap[2]-10).abs**2)**(0.5)
  # puts gap.to_s
  return false if ((gap[0]-10)**2+(gap[1]-10)**2+(gap[2]-10)**2)**(0.5) > 14
  # return true if ((gap[0]-10)**2+(gap[1]-10)**2+(gap[2]-10)**2)**(0.5) < 8
  # return false if steps > 20
  sides = [
    [gap[0]+1,gap[1],gap[2]],
    [gap[0]-1,gap[1],gap[2]],
    [gap[0],gap[1]-1,gap[2]],
    [gap[0],gap[1]+1,gap[2]],
    [gap[0],gap[1],gap[2]-1],
    [gap[0],gap[1],gap[2]+1]
  ]

  open_sides = sides - blocks - @contained

  # gapped_sides = open_sides & gaps

  # return false if gapped_sides != open_sides

  open_sides.each do |side|
    return true if @contained.include?(side)
    return false unless gap_contained?(side, gaps - [gap], blocks + [gap], steps + 1)
  end

  @contained << gap
  return true
end

sides = 0

gaps = {}

lines.each do |line|
  gap = [
  [line[0]+1,line[1],line[2]],
  [line[0]-1,line[1],line[2]],
  [line[0],line[1]-1,line[2]],
  [line[0],line[1]+1,line[2]],
  [line[0],line[1],line[2]-1],
  [line[0],line[1],line[2]+1]
]
  gap = gap - lines

  gap.each do |g|
    gaps[g] ||= 0
    gaps[g] += 1
  end
end

# puts gaps.count
# # puts gaps.select{|k, v| v < 6}.count
# gaps.keys.each{|g| gap_contained?(g, gaps.values, lines, 0)}
# # puts @contained.count
# # # puts gaps.to_s
# # # puts gaps.values.sum

# puts gaps.select{|k,v| !@contained.include?(k)}.values.sum

# colls = []
# gaps.each do |line|
#   other_gs = [
#     [line[0]+1,line[1],line[2]],
#     [line[0]-1,line[1],line[2]],
#     [line[0],line[1]-1,line[2]],
#     [line[0],line[1]+1,line[2]],
#     [line[0],line[1],line[2]-1],
#     [line[0],line[1],line[2]+1]
#   ]

#   collisions = other_gs & gaps

  

#   colls += collisions

#   other_gs.each do |g|
#   end
# end
# puts colls.to_s

# 1851 wrong
# 4216 wrong
# 4029 wrong
# 3666 wrong
# 2898 false
# 3366 wrong
# 2463 wrong
# 2459 wrong

# 2557 wrong

@queued = []

def add_water current, container, rocks
  # print_grid container[0]
  return container if container[current[0]][current[1]][current[2]] == "#"
  return container if container[current[0]][current[1]][current[2]] == "%"

  sides = [
    [current[0]+1,current[1],current[2]],
    [current[0]-1,current[1],current[2]],
    [current[0],current[1]-1,current[2]],
    [current[0],current[1]+1,current[2]],
    [current[0],current[1],current[2]-1],
    [current[0],current[1],current[2]+1]
  ]
  sides = sides.select{|(y,x,z)| y >= -1 && x >= -1 && z >= -1 && y <= 23 && x<=23 && z<=23 }
  sides = sides - @water
  sides = sides - rocks

  sides = sides - @queued
  
  @queued += sides

  # File.open("./water", "w") do |f|
  #   f.puts current.to_s
  # end
  @water << current
  # puts current.to_s
  container[current[0]][current[1]][current[2]] = "%"

  sides.each do |side|
    container = add_water side, container, rocks
  end
  container
end

container = Array.new(25) { Array.new(25) { Array.new(25) { "" } } }
lines.each do |(y,x,z)|
  container[y][x][z] = "#"
end

# gaps.each do |(k,v)|
#   # puts k.to_s
#   container[k[0]][k[1]][k[2]] = "o"
# end

current = [0,0,0]
@water = []


container = add_water current, container, lines

@contained = gaps.keys - @water
 
puts gaps.keys.count
puts @contained.count

puts gaps.select{|k,v| @water.include?(k)}.values.sum

total = 0
lines.each do |line|
  sides = [
    [line[0]+1,line[1],line[2]],
    [line[0]-1,line[1],line[2]],
    [line[0],line[1]-1,line[2]],
    [line[0],line[1]+1,line[2]],
    [line[0],line[1],line[2]-1],
    [line[0],line[1],line[2]+1]
  ]

  sides.each do  |side|
    total += 1 if @water.include?(side)
  end
end

puts total

# def distance gap
#   ((gap[0]-10)**2+(gap[1]-10)**2+(gap[2]-10)**2)**(0.5)
# end

# max = 0
# gaps.each do |(line,_)|
#   if distance(line) > max
#     max = distance line
#     puts "#{line} #{max}"
#   end
# end