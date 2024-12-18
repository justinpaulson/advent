require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
g = Grid.new(lines)

def fence_for_group1 group
  total = 0
  groups = []
  group.each do |location|
    y,x = location
    [[y+1,x],[y-1,x],[y,x+1],[y,x-1]].each do |new_point|
      if !group.include?(new_point)
        total += 1
      end
    end
  end
  total
end

#   A
#  AAAAA
#   A  A
#
#
#
#
#

def fence_for_group2 group
  # count the corners in the contiguous group of locations [[y,x],[y,x],...]
  total = 0
  group.each do |location|
    y,x = location
    if !group.include?([y-1,x])    #       here
      if !group.include?([y,x+1])  #      A
        total += 1
      end                          #  here
      if !group.include?([y,x-1])  #      A
        total += 1
      end
    else
      if !group.include?([y-1,x+1]) #      Ahere
        if group.include?([y,x+1])  #      AA
          total += 1
        end
      end
      if !group.include?([y-1,x-1])  #  hereA
        if group.include?([y,x-1])   #     AA
          total += 1
        end
      end
    end
    if !group.include?([y+1,x])    #      A
      if !group.include?([y,x+1])  #       here
        total += 1
      end                          #      A
      if !group.include?([y,x-1])  #  here
        total += 1
      end
    else
      if !group.include?([y+1,x+1]) #      AA
        if group.include?([y,x+1])  #      Ahere
          total += 1
        end
      end
      if !group.include?([y+1,x-1])  #     AA
        if group.include?([y,x-1])   #  hereA
          total += 1
        end
      end
    end
  end
  total
end

total1 = 0
total2 = 0
letters = ("A".."Z").to_a
letters.each do |letter|
  groups = [[]]
  count = 0
  while location = g.find(letter)
    groups[count] ||= []
    groups[count] << location
    locations = []
    locations << location
    while locations.any?
      location = locations.pop
      g.grid[location[0]][location[1]] = "."
      locations += g.find_adjacent(location, letter)
      groups[count] += locations
    end
    groups[count].uniq!
    count += 1
  end
  groups.each do |group|
    fence1 = fence_for_group1(group)
    fence2 = fence_for_group2(group)
    total1 += group.length * fence1
    total2 += group.length * fence2
  end
end

puts total1
puts total2
