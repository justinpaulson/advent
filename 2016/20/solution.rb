require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp).map{|l| l.split("-").map(&:to_i) }.sort_by{|l| l[0] }

t = -1
target = 0
max = lines[0][1]
white_list = []
while target < 4294967295
  unless (lines[t+1][0] <= target || lines[t+1][1] <= target) && (t == -1 || lines[t][1] <= target)
    white_list << target
    target += 1
    next
  end
  t += 1
  target = [lines[t][1] + 1, target].max
end

puts white_list[0]
puts white_list.count
