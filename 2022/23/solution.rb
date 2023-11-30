require "../../grid"

def should_move grid, elf, round
  adj = [
    [elf[0]+1,elf[1]],
    [elf[0]-1,elf[1]],
    [elf[0],elf[1]+1],
    [elf[0],elf[1]-1],
    [elf[0]+1,elf[1]+1],
    [elf[0]-1,elf[1]-1],
    [elf[0]+1,elf[1]-1],
    [elf[0]-1,elf[1]+1]
  ]
  adj_elves = adj.select{|(y,x)| grid[y][x] == "#"}
  adj_opens = adj.select{|(y,x)| grid[y][x] == "."}

  return [elf, elf] if adj_elves.count == 0
  # puts adj_elves.to_s
  # puts adj_opens.to_s

  checks = ["N","S","W","E"].rotate(round)

  # puts checks.to_s

  checks.each do |check|
    case check
    when "N"
      if adj_opens.include?([elf[0]-1,elf[1]-1]) && adj_opens.include?([elf[0]-1,elf[1]]) && adj_opens.include?([elf[0]-1,elf[1]+1])
        # puts "North #{[elf, [elf[0]-1,elf[1]]].to_s}"
        return [elf, [elf[0]-1,elf[1]]]
      end
    when "S"
      if adj_opens.include?([elf[0]+1,elf[1]-1]) && adj_opens.include?([elf[0]+1,elf[1]]) && adj_opens.include?([elf[0]+1,elf[1]+1])
        # puts "South #{[elf, [elf[0]+1,elf[1]]].to_s}"
        return [elf, [elf[0]+1,elf[1]]]
      end
    when "W"
      if adj_opens.include?([elf[0]-1,elf[1]-1]) && adj_opens.include?([elf[0],elf[1]-1]) && adj_opens.include?([elf[0]+1,elf[1]-1])
        # puts "West #{[elf, [elf[0],elf[1]-1]].to_s}"
        return [elf, [elf[0],elf[1]-1]]
      end
    when "E"
      if adj_opens.include?([elf[0]-1,elf[1]+1]) && adj_opens.include?([elf[0],elf[1]+1]) && adj_opens.include?([elf[0]+1,elf[1]+1])
        # puts "East #{[elf, [elf[0],elf[1]+1]].to_s}"
        return [elf, [elf[0],elf[1]+1]]
      end
    end
  end
  return [elf, elf]
end

lines = IO.readlines("input").map(&:chomp)
grid = new_grid lines.length + 400, lines[0].length + 400, "."
elves = []
lines.each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    if c == "#"
      elves << [y+200,x+200]
      grid[y+200][x+200] = c
    end
  end
end

# print_grid grid

0.upto(10000) do |round|
  proposed_moves = []
  # print_grid grid
  elves.each{|e| proposed_moves << should_move(grid, e, round)}
  # puts proposed_moves.to_s
  
  dups = {}
  proposed_moves.each{|from, to| dups[to] ||= 0; dups[to] += 1}
  dup_proposals = dups.select{|k,v| v > 1}.keys
  # puts "Found the following dupes: #{dup_proposals}"
  stays = proposed_moves.select{|m| m[0] == m[1] || dup_proposals.include?(m[1])}.map(&:first)

  moves = proposed_moves.map(&:last) - stays - dup_proposals
  # puts moves.to_s
  # puts stays.to_s
  out_grid = new_grid grid.length, grid[0].length, "."
  (stays+moves).each do |y,x|
    out_grid[y][x] = "#"
  end
  if elves.sort == (stays+moves).sort
    puts round+1
    exit
  end
  elves = (stays+moves)
  grid = out_grid
end

min_y = grid.length
max_y = 0
min_x = grid[0].length
max_x = 0

grid.each_with_index do |row, i|
  if row.include?("#")
    min_y = i
    break
  end
end



(grid.length-1).downto(0) do |row|
  if grid[row].include?("#")
    max_y = row
    break
  end
end

grid.each do |row|
  min_find = (row.find_index("#") || row.length-1)
  max_find = row.length - 1 - (row.reverse.find_index("#") || (row.length - 1))
  if min_find < min_x
    min_x = min_find
  end
  if max_find > max_x
    max_x = max_find
  end
end

print_grid grid
puts "Min Y: #{min_y}, Max Y: #{max_y}, Min X: #{min_x}, Max X: #{max_x}"

total = 0
min_y.upto(max_y) do |y|
  min_x.upto(max_x) do |x|
    total += 1 if grid[y][x] == "."
  end
end

puts total

# 17045 too high