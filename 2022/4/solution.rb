lines = IO.readlines("input")

ans=0
lines.each do |line|
  first, second = line.split(",")
  f1,f2 = first.split("-").map(&:to_i)
  s1,s2 = second.split("-").map(&:to_i)
  if (f1 <= s1 && f2 >= s1) || (s1 <= f1 && s2 >= f1)
    ans +=1
  end
end


puts ans