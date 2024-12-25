require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.read(ARGV[0]).chomp

locks_and_keys = lines.split("\n\n")

locks = []
keys = []
locks_and_keys.each do |loc|
  loc = loc.split("\n")
  loc = Grid.new(loc)
  if loc.grid[0].include?(".")
    locks << 0.upto(4).map{|i| 0.upto(6).map{|j| loc.grid[j][i] == "#" ? 1 : 0}.sum - 1}
  else
    keys << 0.upto(4).map{|i| 0.upto(6).map{|j| loc.grid[j][i] == "#" ? 1 : 0}.sum - 1}
  end
end

total = 0
keys.each do |key|
  locks.each do |lock|
    add = true
    key.each_with_index do |k, i|
      if key[i] + lock[i] > 5
        add = false
      end
    end
    total += 1 if add
  end
end

puts total
