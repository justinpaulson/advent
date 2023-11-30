lines = IO.readlines("input")

s = 0

lines.each do |line|
  m,t = line.split
case t
when "X"
  s += 1
when "Y"
  s += 2
when "Z"
  s += 3
end
draw = true if (m == "A" && t == "X") || (m == "B" && t == "Y") || (m == "C" && t == "Z")
win = true if (m == "A" && t == "Y") || (m == "B" && t == "Z") || (m == "C" && t == "X")
s += 3 if draw
s += 6 if win
end

puts s

s = 0
lines.each do |line|
  t,o = line.split
  m = case o
  when "X"
    case t
    when "A"
      "C"
    when "B"
      "A"
    when "C"
      "B"
    end
  when "Y"
    m = t
  when "Z"
    case t
    when "A"
      "B"
    when "B"
      "C"
    when "C"
      "A"
    end
  end
  case m
  when "A"
    s += 1
  when "B"
    s += 2
  when "C"
    s += 3
  end
  draw = true if m == t
  win = true if (m == "A" && t == "C") || (m == "B" && t == "A") || (m == "C" && t == "B")
  s += 3 if draw
  s += 6 if win
end

puts s