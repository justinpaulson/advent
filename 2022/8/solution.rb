lines = IO.readlines("input")

def print_grid grid, joiner=""
  puts `clear`
  0.upto(grid.length-1) do |y|
    print y.to_s
    print " "
    puts grid[y].join(joiner)
  end
  # sleep 0.25 
end

def new_grid y, x, fill="."
  Array.new(y) { Array.new(x) { fill } }
end

lines = lines.map{|l| l.chomp}

# trees = new_grid lines.length, lines[0].length, 0
# lines.each_with_index do |line, j|
#   max_tree = -1
#   0.upto(line.length-1) do |i|
#     if max_tree < line[i].to_i
#       trees[j][i] = 1
#       max_tree = line[i].to_i
#     end
#   end

#   max_tree = -1
#   (line.length-1).downto(0) do |i|
#     if max_tree < line[i].to_i
#       trees[j][i] = 1
#       max_tree = line[i].to_i
#     end
#   end
# end

# 0.upto(lines[0].length-1) do |x|
#   max_tree = -1
#   0.upto(lines.length-1) do |i|
#     puts x
#     if max_tree < lines[i][x].to_i
#       trees[i][x] = 1
#       max_tree = lines[i][x].to_i
#     end
#   end

#   max_tree = -1
#   (lines.length-1).downto(0) do |i|
#     if max_tree < lines[i][x].to_i
#       trees[i][x] = 1
#       max_tree = lines[i][x].to_i
#     end
#   end
# end
# print_grid trees
# puts trees.map{|t| t.sum}.sum

def up_trees(trees, y, x)
  mark = trees[y][x].to_i

  seen = 0
  (y-1).downto(0) do |ny|
    if mark > trees[ny][x].to_i
      seen += 1
    else
      seen += 1
      break
    end
  end
  seen
end

def down_trees(trees, y, x)
  mark = trees[y][x].to_i

  seen = 0
  (y+1).upto(trees.length-1) do |ny|
    if mark > trees[ny][x].to_i
      seen += 1
    else
      seen += 1
      break
    end
  end
  seen
end

def right_trees(trees, y, x)
  mark = trees[y][x].to_i

  seen = 0
  (x+1).upto(trees[0].length-1) do |nx|
    if mark > trees[y][nx].to_i
      seen += 1
    else
      seen += 1
      break
    end
  end
  [seen, 1].max
end

def left_trees(trees, y, x)
  mark = trees[y][x].to_i

  seen = 0
  (x-1).downto(0) do |nx|
    if mark > trees[y][nx].to_i
      seen += 1
    else
      seen += 1
      break
    end
  end
  seen
end

max_trees = 0

maxes = new_grid lines.length, lines[0].length, 0

0.upto(lines.length-1) do |y|
  0.upto(lines[0].length-1) do |x|
    trees = right_trees(lines, y, x) * left_trees(lines, y, x) * down_trees(lines, y, x) * up_trees(lines, y, x)
    puts trees
    maxes[y][x] = trees
    if max_trees < trees
      max_trees = trees
    end
  end
end

print_grid maxes, ","

puts max_trees