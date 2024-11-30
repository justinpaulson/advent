require '../../grid.rb'

ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

grid = new_grid lines.length, lines[0].length

lines.each_with_index do |line, y|
  line.each_char.with_index do |char, x|
    grid[y][x] = char
  end
end

# part 1
#
#
# grid = grid.transpose

# total = 0

# grid.each_with_index do |line, y|
#   line_total = 0

#   rocks = line.each_index.select{|i| line[i] == 'O'}
#   beams = line.each_index.select{|i| line[i] == '#'}
#   rock_counts = []
#   beams.each_with_index do |beam, i|
#     rocks_before_this_beam = rocks.select{|rock| rock < beam && ((i > 0 && rock > beams[i-1]) || i == 0)}.count

#     rock_counts << rocks_before_this_beam
#   end
#   if beams.length > 0
#     rocks_at_the_end = rocks.select{|rock| rock > beams[-1]}.count
#   else
#     rocks_at_the_end = rocks.count
#   end
#   rock_counts << rocks_at_the_end

#   far_left = rock_counts.shift

#   1.upto(far_left) do |rock|
#     line_total += line.length - rock + 1
#   end
#   beams.each_with_index do |beam, i|
#     1.upto(rock_counts[i]) do |rock|
#       line_total += line.length - beam - rock
#     end
#   end

#   total += line_total
# end

# puts total

def move_rocks_left grid
  grid = grid.map do |line|
    rocks = line.each_index.select{|i| line[i] == 'O'}
    beams = line.each_index.select{|i| line[i] == '#'}
    rock_counts = []
    beams.each_with_index do |beam, i|
      rocks_before_this_beam = rocks.select{|rock| rock < beam && ((i > 0 && rock > beams[i-1]) || i == 0)}.count
      rock_counts << rocks_before_this_beam
    end
    if beams.length > 0
      rocks_at_the_end = rocks.select{|rock| rock > beams[-1]}.count
    else
      rocks_at_the_end = rocks.count
    end
    rock_counts << rocks_at_the_end

    new_line = ""
    rock_counts.each_with_index do |num_rocks, i|
      new_line += "O" * num_rocks
      new_line += "." * (beams[i] - new_line.length) + "#" if beams[i]
    end

    new_line += "." * (line.length - new_line.length)

    new_line.chars
  end
end


def cycle_grid grid
  # print_grid grid, "", true, true

  grid = rotate_grid(grid, "ccw")

  # print_grid grid, "", true, true

  grid = move_rocks_left(grid)

  # print_grid grid, "", true, true

  grid = rotate_grid(grid, "cw")

  # print_grid grid, "", true, true

  grid = move_rocks_left(grid)

  # print_grid grid, "", true, true

  grid = rotate_grid(grid, "cw")

  # print_grid grid, "", true, true

  grid = move_rocks_left(grid)

  # print_grid grid, "", true, true

  grid = rotate_grid(grid, "cw")

  # print_grid grid, "", true, true

  grid = move_rocks_left(grid)

  # print_grid grid, "", true, true

  grid = rotate_grid(grid, "cw")
  grid = rotate_grid(grid, "cw")

  # print_grid grid, "", true, true

  grid
end

def grid_total grid
  grid = rotate_grid(grid, "ccw")

  total = 0
  grid.each do |line|
    line.each_index.select{|i| line[i] == 'O'}.each do |rock|
      total += line.length - rock
    end
  end
  total
end

grids = {}

last_cycle = {}
10000.times do |i|
  if i % 100000 == 0
    # print_grid grid
    puts i
  end
  grids[grid] ||= 0
  last_cycle[grid] = i
  grids[grid] += 1
  # if grids[grid] > 1
  #   puts "found a loop at #{i}, grids total = #{grids.count}, last cycle = #{last_cycle[grid]}"
  #   puts grids.values.to_s
  #   puts last_cycle.values.to_s
  # end
  grid = cycle_grid(grid)
end

rotation = grids.select{|k,v| v > 1}.keys

totals = rotation.map{|grid| grid_total(grid)}.uniq.sort

puts totals.to_s

puts last_cycle.select{|k,v| rotation.include?(k)}.values.to_s

# too low
# 118729


# 118736, 118737, 118740, 118741, 118747, 118748, 118749, 118752, 118754, 118755, 118756, 118758, 118759, 118760, 118762

# too high
# 118763
# 118792
