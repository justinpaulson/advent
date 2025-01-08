ARGV[0] ||= "input"
lines = File.readlines(ARGV[0])

def cookie_for toppings, vals
  totals = [0, 0, 0, 0]
  toppings.each_with_index do |top, i|
    top[1][0..-2].each_with_index do |top_val, ind|
      totals[ind] += (top_val * vals[i])
    end
  end
  totals = totals.map{|t| t > 0 ? t : 0 }
  totals.inject(1, :*)
end

toppings = []

lines.each do |line|
  name, details = line.split(":")
  tops = details.split(", ").map{|d| att, val = d.split; [att, val.to_i] }
  tops = tops.map{|t| t[1]}
  toppings << [name, tops]
end

best = 0

0.upto(100) do |a|
  0.upto(100) do |b|
    0.upto(100) do |c|
      0.upto(100) do |d|
        next unless a + b + c + d == 100
        t = cookie_for toppings, [a, b, c, d]
        best = t if t > best
      end
    end
  end
end

puts best

t=0
best =0

0.upto(500/(toppings[0][1][4])) do |a|
  0.upto(500/(toppings[1][1][4])) do |b|
    0.upto(500/(toppings[2][1][4])) do |c|
      0.upto(500/(toppings[3][1][4])) do |d|
        next unless a + b + c + d == 100 && toppings[0][1][4]*a + toppings[1][1][4]*b + toppings[2][1][4]*c + toppings[3][1][4]*d == 500
        t = cookie_for toppings, [a, b, c, d]
        best = t if t > best
      end
    end
  end
end

puts best
