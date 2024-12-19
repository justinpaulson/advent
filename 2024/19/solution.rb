require '../../grid.rb'

@how_many_makes_rec_cache = {}
def how_many_makes_rec req, towels, view=false
  return @how_many_makes_rec_cache[req] if @how_many_makes_rec_cache[req]
  if req == ""
    @how_many_makes_rec_cache[req] = 1
    return 1
  end
  possible_towels = (towels).select { |towel| req[0..towel.length-1] == towel }
  if possible_towels.empty?
    @how_many_makes_rec_cache[req] = 0
    return 0
  end

  puts possible_towels.to_s if view

  total = 0
  possible_towels.each do |towel|
    if req == towel
      total += 1
    else
      total += how_many_makes_rec(req[towel.length..-1], towels, view)
    end
  end
  @how_many_makes_rec_cache[req] = total
  total
end

ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

towels = lines[0].chomp.split(", ")
reqs = lines[2..-1]


# very slow in ruby, see rust implementation
count = 0
total = 0
reqs.reverse.each do |req|
  total_makes = how_many_makes_rec(req, towels)
  total += total_makes
  count += 1 if total_makes > 0
end

puts count
puts total
