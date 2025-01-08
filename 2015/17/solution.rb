ARGV[0] ||= "input"
conts = IO.readlines(ARGV[0]).map(&:to_i).sort

total = 150
wins = []

2.upto(20) do |i|
  conts.combination(i).each do |arr|
    wins << arr.sort if arr.sum == 150
  end
end

puts wins.count

p wins.sum{|win| win.length == wins.min{|w| w.length}.length ? 1 : 0}
