# [P]     [C]         [M]            
# [D]     [P] [B]     [V] [S]        
# [Q] [V] [R] [V]     [G] [B]        
# [R] [W] [G] [J]     [T] [M]     [V]
# [V] [Q] [Q] [F] [C] [N] [V]     [W]
# [B] [Z] [Z] [H] [L] [P] [L] [J] [N]
# [H] [D] [L] [D] [W] [R] [R] [P] [C]
# [F] [L] [H] [R] [Z] [J] [J] [D] [D]
#  1   2   3   4   5   6   7   8   9

bins = [[], %w(P D Q R V B H F),
%w(V W Q Z D L), %w(C P R G Q Z L H), %w(B V J F H D R), %w(C L W Z), %w(M V G T N P R J),
%w(S B M V L R J), %w(J P D), %w(V W N C D)]
puts bins.to_s

moves = IO.readlines("input")

moves.each do |m|
  num, parts = m.split(" from ")
  num = num.split(" ").last.to_i
  from, to = parts.split(" to ").map(&:to_i)
  num.times do
    bins[to].unshift(bins[from].shift)
  end
end

bins[1..9].map do |b|
  print b.first
end

bins = [[], %w(P D Q R V B H F),
%w(V W Q Z D L), %w(C P R G Q Z L H), %w(B V J F H D R), %w(C L W Z), %w(M V G T N P R J),
%w(S B M V L R J), %w(J P D), %w(V W N C D)]
puts bins.to_s

moves = IO.readlines("input")

moves.each do |m|
  num, parts = m.split(" from ")
  num = num.split(" ").last.to_i
  from, to = parts.split(" to ").map(&:to_i)
  
  bins[to] = bins[from][0..num-1] + bins[to]
  bins[from] = bins[from][num..-1]
end

bins[1..9].map do |b|
  print b.first
end