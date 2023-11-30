lines = IO.readlines("input").map(&:chomp)

# keypad
# 1 2 3
# 4 5 6
# 7 8 9

# keypad 2
#  
#     1
#   2 3 4
# 5 6 7 8 9
#   A B C
#     D


def num_for x, y
  [
    "  1",
    " 234",
    "56789",
    " ABC",
    "  D"
  ][y][x]
end

x = 0
y = 2

code = ""

lines.each do |line|
  line.chars.each do |dir|
    case dir
    when "U"
      if y > 2 || (y > 1 && x > 0 && x < 4) || ( y > 0 && x == 2)
        y -= 1
      end
    when "D"
      if y < 2 || (y < 3 && x > 0 && x < 4) || ( y < 4 && x == 2)
        y += 1
      end
    when "R"
      if x < 2 || (x < 3 && y > 0 && y < 4) || ( x < 4 && y == 2)
        x += 1
      end
    when "L"
      if x > 2 || (x > 1 && y > 0 && y < 4) || ( x > 0 && y == 2)
        x -= 1
      end
    end
  end
  code << num_for(x,y)
end

puts code