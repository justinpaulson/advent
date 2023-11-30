lines = File.readlines("input")

p lines.map{|line| i=line.chomp.split(" ").map(&:to_i);i.max-i.min; }.sum

p lines.map{|line| i=line.chomp.split(" ").map(&:to_i);i.permutation(2).select{|x,y| x/y * y == x || y/x * x == y}.map{|x,y|[x,y].sort}.map{|x,y| y/x}[0]}.sum

