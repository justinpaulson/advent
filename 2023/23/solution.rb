require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
@grid = new_grid lines.length, lines[0].length
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    @grid[y][x] = char
  end
end

###### part 1 VVV #######

# start = [0,1]

# paths = [[start]]

# terminal_paths = []

# while paths.length > 0
#   puts paths.length
#   path = paths.shift
#   y, x = path.last

#   next_moves = []
#   case grid[y][x]
#   when "<"
#     next_moves = [[y,x-1]] if [y,x-1] != path[-2]
#   when ">"
#     next_moves = [[y,x+1]] if [y,x+1] != path[-2]
#   when "^"
#     next_moves = [[y-1,x]] if [y-1,x] != path[-2]
#   when "v"
#     next_moves = [[y+1,x]] if [y+1,x] != path[-2]
#   when "."
#     [[-1,0], [1,0], [0,-1], [0,1]].each do |dx, dy|
#       new_x = x + dx
#       new_y = y + dy
#       next if path.include?([new_y, new_x])
#       next if new_y < 0 || new_y >= grid.length || new_x < 0 || new_x >= grid[0].length
#       next if grid[new_y][new_x] == "#"

#       next_moves << [new_y, new_x]
#     end
#   end

#   if next_moves.length == 0
#     terminal_paths << { length: path.length - 1, path: path }
#   else
#     next_moves.each do |next_move|
#       paths << path + [next_move]
#     end
#   end
# end

# puts terminal_paths.map{|p| p[:length]}.max

######  part 1 ^^^ #######
# nodes = []
# if ARGV[0] == "test"
#   nodes = [
#     [0, 1],
#     [3, 11],
#     [5, 3],
#     [13, 5],
#     [11, 21],
#     [13, 13],
#     [19, 13],
#     [19, 19],
#     [22, 21]
#   ]
# else
#   nodes = [
#     [0, 1],
#     [7, 17],
#     [19, 35],
#     [5, 55],
#     [9, 77],
#     [17, 107],
#     [41, 137],
#     [31, 113],
#     [31, 75],
#     [29, 63],
#     [29, 35],
#     [43, 5],
#     [55, 137],
#     [53, 105],
#     [67, 83],
#     [59, 67],
#     [67, 29],
#     [61, 9],
#     [77, 133],
#     [89, 109],
#     [79, 89],
#     [81, 65],
#     [81, 33],
#     [75, 17],
#     [105, 131],
#     [107, 103],
#     [111, 79],
#     [113, 59],
#     [113, 33],
#     [99, 7],
#     [123, 133],
#     [133, 101],
#     [133, 75],
#     [135, 61],
#     [131, 33],
#     [140, 139]
#   ]
# end

def get_length path
  return 0 if path.length == 1
  0.upto(path.length - 2).map{|i| @distances[[path[i], path[i+1]]]}.reduce(:+)
end

### get nodes vvvvvv
###
start = [0,1]

terminal_paths = []

node_count = {}
viewed_nodes = []

0.upto(@grid.length - 1) do |y|
  0.upto(@grid[0].length - 1) do |x|
    next if @grid[y][x] == "#"
    next_moves = []
    [[-1,0], [1,0], [0,-1], [0,1]].each do |dx, dy|
      new_x = x + dx
      new_y = y + dy
      next if new_y == @grid.length || new_y < 0
      next if new_x == @grid[0].length || new_x < 0
      next if @grid[new_y][new_x] == "#"

      next_moves << [new_y, new_x]
    end

    if next_moves.count > 2
      node_count[[y,x]] ||= 1
    end
  end
end

nodes = [[0,1]] + node_count.keys + [[@grid.length - 1, @grid[0].length - 2]]


@distances = {}

nodes.each do |node|
  start = node
  paths = [[start]]

  while paths.length > 0
    path = paths.pop
    current = path.last

    if current != node && nodes.include?(current)
      @distances[[node, current]] = path.length - 1
      next
    end

    next if current[0] == @grid.length - 1
    y, x = current
    next_moves = []
    [[-1,0], [1,0], [0,-1], [0,1]].each do |dx, dy|
      new_x = x + dx
      new_y = y + dy
      next if @grid[new_y][new_x] == "#"
      next if path.include?([new_y, new_x])
      next_moves << [new_y, new_x]
    end

    if next_moves.length == 0
      next
    elsif next_moves.length == 1
      paths << path + next_moves
    elsif path.length == 1
      next_moves.each{|next_m| paths << path + [next_m]}
    else
      puts "ERROR oh crap"
    end
  end
end

@connections = {}

@distances.keys.each do |(from, to)|
  @connections[from] ||= []
  @connections[from] << to
end

# failed_paths = []
# terminal_paths = []

paths = [[[0,1]]]

max_path = 0
while paths.length > 0
  path = paths.pop

  current = path.last

  if current[0] == @grid.length - 1
    path_length = get_length(path)
    # terminal_paths << path
    if path_length > max_path
      max_path = path_length
      # puts terminal_paths.map{|p| p[:length]}.max}
      # puts path.to_s
      # puts "Failed total: #{failed_paths.length}, terminal: #{terminal_paths.length}, total: #{failed_paths.length + terminal_paths.length}"
      puts max_path
    end
    next
  end

  # puts current.to_s

  # puts connections.to_s

  next_moves = @connections[current].select{|c| !path.include?(c)}

  next if next_moves.length == 0

  next_moves.each{|next_m| paths << path + [next_m]}
end



# # too low
# # 1910
# # 2106
# # 6402
