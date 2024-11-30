def validate_config? line, pattern
  test_pattern = pattern.dup
  original_line = line.dup
  while(!test_pattern.empty?)
    current_num = test_pattern.shift

    current_streak = 0
    line = line[1..-1] while line[0] == "."
    while line[0] == "#"
      current_streak += 1
      line = line[1..-1]
    end
    return false if current_streak != current_num
  end
  unless line.include?("#")
    puts "line: #{original_line} is valid!"
    return true
  end
  return false
end

@possibles = {}

def get_possible_configs line, pattern
  puts "Now testing line: #{line} with pattern: #{pattern.to_s}"
  return @possibles[[line, pattern]] if @possibles[[line, pattern]]
  return (@possibles[[line, pattern]] = 1) if pattern.empty? && (line.nil? || !line.include?("#"))
  return (@possibles[[line, pattern]] = 0) if pattern.empty? && line.include?("#")
  return (@possibles[[line, pattern]] = 0) if line.nil? && !pattern.empty?
  return (@possibles[[line, pattern]] = 0) if pattern[0] > line.length
  return (@possibles[[line, pattern]] = 0) if line.count("#") > pattern.sum
  return (@possibles[[line, pattern]] = 0) if line.count("#") + line.count("?") < pattern.sum
  return (@possibles[[line, pattern]] = 0) if line.length < pattern.sum + pattern.count - 1

  possible_total = 0
  possible_positions = []
  num = pattern.first
  positions = []

  remaining = 0
  remaining = pattern.count > 1 ? pattern[1..-1].sum : 0

  start = 0
  start += 1 while line[start] == "."

  while start + num <= line.length
    possible_positions << start if !line[start..start+num-1].include?(".") &&
      line[start+num] != "#" &&
      (start == 0 || (start > 0 && line[0..start-1].count("#") == 0))

    start += 1
  end

  puts "Found possible_positions: #{possible_positions.to_s}"

  possible_positions.each do |position|
    new_line = line.dup
    new_line = new_line[position+num+1..-1]
    possible_total += get_possible_configs(new_line, pattern[1..-1])
  end

  @possibles[[line, pattern]] = possible_total

  # puts "Returning #{possible_total}"

  possible_total
end

ARGV[0] ||= "input"

lines = IO.readlines(ARGV[0]).map(&:chomp).map(&:split).map do |(line, pattern)|
  [line, pattern.split(',').map(&:to_i)]
end

total = 0

lines.each do |(line, pattern)|
  puts "Now testing line: #{line} with pattern: #{pattern.to_s}"
  possible = get_possible_configs line, pattern
  puts "Possible: #{possible}"
  total += possible
end

puts total

lines = lines.map do |(line, pattern)|
  [([line]*5).join("?"), pattern*5]
end

total = 0
lines.each do |(line, pattern)|
  puts "Now testing line: #{line} with pattern: #{pattern.to_s}"
  possible = get_possible_configs line, pattern
  puts "Possible: #{possible}"
  total += possible
end

puts total


# too high
# 547662448073828893
# 17093496990839
# 527570479489

# nope
# 536220314926
