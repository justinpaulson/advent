line = IO.read("input")
# line = "bvwbjplbgvbhsrlpgdmjqwftvncz"

0.upto(line.length-1) do |i|
  a = line[i]
  b = line[i+1]
  c = line[i+2]
  d = line[i+3]
  if [a,b,c,d] == [a,b,c,d].uniq
    puts i+4
    break
  end
end

0.upto(line.length-14) do |i|
  if line[i..i+13].chars == line[i..i+13].chars.uniq
    puts i+14
    break
  end
end
