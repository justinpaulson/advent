require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

lines.map! { |line| line.split(" ")}
operations = lines[-1]

totals = []
operations.each{|op| totals << (op == "+" ? 0 : 1)}
lines[0..-2].each do |line|
  line.each_with_index do |num, idx|
    if operations[idx] == "+"
      totals[idx] += num.to_i
    else
      totals[idx] *= num.to_i
    end
  end
end

puts totals.sum

total = 0

lines = IO.readlines(ARGV[0]).map(&:chomp)
breakpoints = Array.new(lines[0].length) { 1 }
lines.map!{|line| line.chars.each_with_index.map{|c, idx| breakpoints[idx] = 0 unless c == " "; c}}
breakpoints = breakpoints.map.with_index{|b, idx| b == 1 ? idx : nil}.compact

([-1]+breakpoints+[lines.map(&:length).max]).each_cons(2) do |bp1, bp2|
  nums = Array.new(bp2 - bp1 - 1) { "" }
  (bp2-1).downto(bp1+1).each do |col|
    lines.each do |line|
      nums[col - (bp1+1)] += line[col] unless line.length <= col || line[col] == " "
    end
  end
  nums.map!(&:to_i)
  if lines[-1][bp1+1] == "+"
    total += nums.sum
  else
    total += nums.inject(1, :*)
  end
end

puts total
