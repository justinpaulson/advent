require '../../grid.rb'

def can_make req, towels, view=false
  cursor = 0
  chain = []
  possible_towels = []
  while cursor < req.length
    possible_towels << (towels).select { |towel| req[cursor..cursor+towel.length-1] == towel }
    puts "cursor: #{cursor} chain: #{chain} possible_towels: #{possible_towels}" if view
    if possible_towels.last.empty?
      if cursor == 0
        return false
      end

      if possible_towels.flatten.empty?
        return false
      end

      while possible_towels.last.empty?
        cursor -= chain.last.length
        chain.pop
        possible_towels.pop
      end
    end
    chain << possible_towels.last.pop
    cursor += chain.last.length
  end
  true
end

def how_many_makes_rec req, towels, view=false
  return 1 if req == ""
  possible_towels = (towels).select { |towel| req[0..towel.length-1] == towel }
  return 0 if possible_towels.empty?

  puts possible_towels.to_s if view

  total = 0
  possible_towels.each do |towel|
    if req == towel
      total += 1
    else
      total += how_many_makes_rec(req[towel.length..-1], towels, view)
    end
  end
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
  puts "req: #{req}"
  puts "total_makes: #{total_makes}"
  total += total_makes
  count += 1 if total_makes > 0
end

puts count
puts total
