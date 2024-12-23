require '../../grid.rb'
ARGV[0] ||= "input"
prizes = IO.read(ARGV[0]).chomp.split("\n\n")

prizes = prizes.map do |raw_prize|
  a,b,location = raw_prize.split("\n")
  a = a.split(": X+")[1]
  a = a.split(", Y+").map(&:to_f)
  b = b.split(": X+")[1]
  b = b.split(", Y+").map(&:to_f)
  location = location.split(": X=")[1]
  location = location.split(", Y=").map(&:to_f)
  {
    a: a, b: b, location: location
  }
end

def least_tokens(prize)
  a = prize[:a]
  b = prize[:b]
  location = prize[:location]
  a_val = (location[1] - (location[0] * b[1]) / b[0].to_f) /  (a[1] - (a[0] * b[1]) / b[0].to_f)
  b_val = (location[0] - a_val * a[0]) / b[0].to_f
  a_val = a_val.to_i
  b_val = b_val.to_i
  (b_val - 10).upto(b_val + 10) do |b_val|
    (a_val - 10).upto(a_val + 10) do |a_val|
      if b_val * b[0] + a_val * a[0] == location[0] && b_val * b[1] + a_val * a[1] == location[1]
        return a_val * 3 + b_val
      end
    end
  end
  0
end

total = 0
prizes.each do |prize|
  total += least_tokens(prize)
end

puts total

prizes = prizes.map do |prize|
  {
    a: prize[:a], b: prize[:b], location: [prize[:location][0] + 10000000000000, prize[:location][1] + 10000000000000]
  }
end

total = 0
prizes.each do |prize|
  total += least_tokens(prize)
end

puts total
