ARGV[0] ||= "input"

require '../../grid.rb'

lines = IO.readlines(ARGV[0]).map(&:chomp)

# new_lines = []
# lines.each do |line|
#   new_lines << line.chars
#   if line.chars.all?{|c| c == "."}
#     new_lines << line.chars
#   end
# end

# new_lines = new_lines.transpose.map(&:reverse)

# final_lines = []

# new_lines.each do |line|
#   final_lines << line
#   if line.all?{|c| c == "."}
#     final_lines << line
#   end
# end

# lines = final_lines.transpose.map(&:reverse)

# galaxies = []


# lines.each_with_index do |line, y|
#   line.each_with_index do |char, x|
#     if char == "#"
#       galaxies << [y,x]
#     end
#   end
# end

# def distance galaxy_from, galaxy_to
#   (galaxy_from[0] - galaxy_to[0]).abs + (galaxy_from[1] - galaxy_to[1]).abs
# end

# totals = {}
# galaxies.each do |galaxy_from|
#   galaxies.each do |galaxy_to|
#     next if galaxy_from == galaxy_to
#     next if totals[[galaxy_to, galaxy_from]] || totals[[galaxy_from, galaxy_to]]
#     totals[[galaxy_from, galaxy_to]] = distance(galaxy_from, galaxy_to)
#   end
# end

# puts totals.values.sum

lines = lines.map(&:chars)

@empty_rows = []
@empty_columns = []
lines.each_with_index do |line, i|
  @empty_rows << i if line.all?{|c| c == "."}
end

lines.transpose.each_with_index do |line, i|
  @empty_columns << i if line.all?{|c| c == "."}
end

galaxies = []

lines.each_with_index do |line, y|
  line.each_with_index do |char, x|
    if char == "#"
      galaxies << [y,x]
    end
  end
end

def distance galaxy_from, galaxy_to
  total = 0
  total += (galaxy_from[0] - galaxy_to[0]).abs + (galaxy_from[1] - galaxy_to[1]).abs
  @empty_columns.each do |empty_column|
    if (galaxy_from[1] < empty_column && galaxy_to[1] > empty_column) ||
      (galaxy_from[1] > empty_column && galaxy_to[1] < empty_column)
      total += 999999
    end
  end
  @empty_rows.each do |empty_row|
    if (galaxy_from[0] < empty_row && galaxy_to[0] > empty_row) ||
      (galaxy_from[0] > empty_row && galaxy_to[0] < empty_row)
      total += 999999
    end
  end
  total
end

totals = {}
galaxies.each do |galaxy_from|
  galaxies.each do |galaxy_to|
    next if galaxy_from == galaxy_to
    next if totals[[galaxy_to, galaxy_from]] || totals[[galaxy_from, galaxy_to]]
    totals[[galaxy_from, galaxy_to]] = distance(galaxy_from, galaxy_to)
  end
end

puts @empty_rows.inspect
puts @empty_columns.inspect

puts totals.values.sum


#nopes
# 425815251676
