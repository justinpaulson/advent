ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
paper = 0
ribbon = 0
lines.each do |line|
  l,w,h = line.split("x").map(&:to_i)
  paper += 2*l*w + 2*w*h + 2*h*l + [l*w, w*h, h*l].min
  ribbon += [2*l+2*w, 2*w+2*h, 2*h+2*l].min + l*w*h
end
puts paper
puts ribbon
