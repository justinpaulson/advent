require '../../grid.rb'
ARGV[0] ||= "input"
ranges, ingredients = IO.read(ARGV[0]).split("\n\n")
ranges = ranges.split("\n")
ingredients = ingredients.split("\n").map(&:to_i)

ranges = ranges.map do |range|
  start, stop = range.split("-").map(&:to_i)
  (start..stop)
end

valid_ingredients = ingredients.select do |ingredient|
  ranges.any? { |range| range.include?(ingredient) }
end

puts valid_ingredients.count

def merge_ranges(range1, range2)
  return nil if range1.end < range2.begin - 1 || range2.end < range1.begin - 1

  new_begin = range1.begin
  new_end = [range1.end, range2.end].max
  (new_begin..new_end)
end

ranges = ranges.sort_by(&:begin)

def merge_all(ranges)
  cursor = 0
  while cursor < ranges.length - 1
    merged_range = merge_ranges(ranges[cursor], ranges[cursor + 1])
    if merged_range
      ranges[cursor] = merged_range
      ranges.delete_at(cursor + 1)
    else
      cursor += 1
    end
  end
end

old_ranges = ranges.dup
merge_all(ranges)

while old_ranges != ranges
  old_ranges = ranges.dup
  merge_all(ranges)
end

valid_ingredients = 0
ranges.each do |range|
  valid_ingredients += (range.end - range.begin + 1)
end

puts valid_ingredients
