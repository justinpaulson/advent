lines = IO.readlines("input")

commands = lines.map{|line| dir, num = line.split; num=num.to_i; [dir, num]}

h1 = 0
h2 = 0
d1 = 0
d2 = 0

a = 0

commands.each do |dir, num|
  case dir
  when "forward"
    h1 += num
    h2 += num
    d2 += a * num
  when "backward"
    h1 -= num
  when "down"
    d1 += num
    a += num
  when "up"
    d1 -= num
    a -= num
  end
end

p d1 * h1
p d2 * h2