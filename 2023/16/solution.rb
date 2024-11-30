require '../../grid.rb'

ARGV[0] ||= "input"

lines = IO.readlines(ARGV[0]).map(&:chomp)

grid = new_grid(lines.length, lines[0].length)



lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    grid[y][x] = char
  end
end

def get_max_energy initial_beam, grid
  puts initial_beam.to_s
  beams = [initial_beam.dup]
  energized = {}
  energized_count = 0
  previous_energized = 0
  beam_positions = []
  while beams.any?{|b| 0 <= b[0] && b[0] < grid.length && 0 <= b[1] && b[1] < grid[0].length && !beam_positions.include?(b)}
    # puts beams.count{|b| 0 <= b[0] && b[0] < grid.length && 0 <= b[1] && b[1] < grid[0].length}
    if previous_energized == energized.keys.count
      energized_count += 1
    else
      energized_count = 0
    end
    previous_energized = energized.keys.count
    break if energized_count > 100
    beam_positions.each do |beam|
      beams.delete(beam)
    end
    beams.each do |beam|
      next if beam[0] < 0 || beam[0] >= grid.length || beam[1] < 0 || beam[1] >= grid[0].length
      energized[[beam[0],beam[1]]] ||= 0
      energized[[beam[0],beam[1]]] += 1

      next if beam_positions.include?(beam)
      beam_positions << beam.dup

      case beam[2]
      when "R"
        case grid[beam[0]][beam[1]]
        when "/"
          beam[0] -= 1
          beam[2] = "U"
        when "\\"
          beam[0] += 1
          beam[2] = "D"
        when "|"
          beam[0] += 1
          beam[2] = "D"
          beams << [beam[0] - 1, beam[1], "U"]
        else
          beam[1] += 1
        end
      when "L"
        case grid[beam[0]][beam[1]]
        when "/"
          beam[0] += 1
          beam[2] = "D"
        when "\\"
          beam[0] -= 1
          beam[2] = "U"
        when "|"
          beam[0] -= 1
          beam[2] = "U"
          beams << [beam[0] + 1, beam[1], "D"]
        else
          beam[1] -= 1
        end
      when "U"
        case grid[beam[0]][beam[1]]
        when "/"
          beam[1] += 1
          beam[2] = "R"
        when "\\"
          beam[1] -= 1
          beam[2] = "L"
        when "-"
          beam[1] -= 1
          beam[2] = "L"
          beams << [beam[0], beam[1] + 1, "R"]
        else
          beam[0] -= 1
        end
      when "D"
        case grid[beam[0]][beam[1]]
        when "/"
          beam[1] -= 1
          beam[2] = "L"
        when "\\"
          beam[1] += 1
          beam[2] = "R"
        when "-"
          beam[1] += 1
          beam[2] = "R"
          beams << [beam[0], beam[1] - 1, "L"]
        else
          beam[0] += 1
        end
      end
    end
  end
  energized.keys.count
end

beams = [[0,3,"D"]]

energized_totals = {}

# (grid[0].length - 1).downto(0) do |x|
# # 0.upto(grid[0].length - 1) do |x|
#   beam = [0,x,"D"]
#   energized_totals[beam] = get_max_energy beam, grid
#   beam = [grid.length - 1,x,"U"]
#   energized_totals[beam] = get_max_energy beam, grid
#   puts energized_totals.values.max
# end

(grid.length - 1).downto(0) do |y|
# 0.upto(grid.length - 1) do |y|
  beam = [y,0,"R"]
  energized_totals[beam] = get_max_energy beam, grid
  beam = [y,grid[0].length - 1,"L"]
  energized_totals[beam] = get_max_energy beam, grid
  puts energized_totals.values.max
end


puts energized_totals.values.max

# too low!!
# 7753

# Wrong
# 7790
# 7791
