ARGV[0] ||= "input"

lines = IO.readlines(ARGV[0])


def get_next_value line
  numbers = line.split.map(&:to_i)

  diffs = [numbers]

  diff_index = 0
  while !diffs[diff_index].all? { |n| n == 0 }
    i = 0
    while i < diffs[diff_index].length - 1
      diffs[diff_index + 1] ||= []
      diffs[diff_index + 1] << diffs[diff_index][i+1] - diffs[diff_index][i]
      i += 1
    end
    diff_index += 1
  end

  puts diffs.to_s

  diffs[diff_index] << 0

  diff_index -= 1
  while diff_index >= 0
    diffs[diff_index] << diffs[diff_index].last + diffs[diff_index + 1].last
    diff_index -= 1
  end

  puts diffs.to_s

  puts diffs[0].last

  diffs[0].last
end

def get_first_value line
  numbers = line.split.map(&:to_i)

  diffs = [numbers]

  diff_index = 0
  while !diffs[diff_index].all? { |n| n == 0 }
    i = 0
    while i < diffs[diff_index].length - 1
      diffs[diff_index + 1] ||= []
      diffs[diff_index + 1] << diffs[diff_index][i+1] - diffs[diff_index][i]
      i += 1
    end
    diff_index += 1
  end

  puts diffs.to_s

  diffs[diff_index].prepend(0)

  diff_index -= 1
  while diff_index >= 0
    diffs[diff_index].prepend( diffs[diff_index].first - diffs[diff_index + 1].first)
    diff_index -= 1
  end

  puts diffs.to_s

  puts diffs[0].first

  diffs[0].first
end

total = 0

lines.each do |line|
  total += get_first_value line
end

puts total
