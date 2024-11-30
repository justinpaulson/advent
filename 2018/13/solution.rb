require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
carts = []
grid = new_grid lines.length, lines[0].length
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    if char == "<"
      carts << [y, x, "<", 0, carts.length]
    elsif char == ">"
      carts << [y, x, ">", 0, carts.length]
    elsif char == "^"
      carts << [y, x, "^", 0, carts.length]
    elsif char == "v"
      carts << [y, x, "v", 0, carts.length]
    end
    if char == "<" || char == ">"
      grid[y][x] = "-"
    elsif char == "^" || char == "v"
      grid[y][x] = "|"
    else
      grid[y][x] = char
    end
  end
end

def collided_carts carts
  carts.each do |cart|
    next if @dead_indexes.include?(cart[4])
    carts.each do |cart_two|
      next if cart == cart_two
      next if @dead_indexes.include?(cart_two[4])
      return true if cart[0] == cart_two[0] && cart[1] == cart_two[1]

      return true if cart[0] == cart_two[0] + 1 && cart[1] == cart_two[1] && cart[2] == "v" && cart_two[2] == "^"
      return true if cart[0] == cart_two[0] - 1 && cart[1] == cart_two[1] && cart[2] == "^" && cart_two[2] == "v"
      return true if cart[0] == cart_two[0] && cart[1] == cart_two[1] + 1 && cart[2] == ">" && cart_two[2] == "<"
      return true if cart[0] == cart_two[0] && cart[1] == cart_two[1] - 1 && cart[2] == "<" && cart_two[2] == ">"
    end
  end
  false
end

def collision_location carts
  carts.each do |cart|
    next if @dead_indexes.include?(cart[4])
    carts.each do |cart_two|
      next if cart == cart_two
      next if @dead_indexes.include?(cart_two[4])
      return "#{cart[1]},#{cart[0]}" if cart[0] == cart_two[0] && cart[1] == cart_two[1]

      return "#{cart[1]},#{cart[0]}" if cart[0] == cart_two[0] + 1 && cart[1] == cart_two[1] && cart[2] == "v" && cart_two[2] == "^"
      return "#{cart[1]},#{cart[0]}" if cart[0] == cart_two[0] - 1 && cart[1] == cart_two[1] && cart[2] == "^" && cart_two[2] == "v"
      return "#{cart[1]},#{cart[0]}" if cart[0] == cart_two[0] && cart[1] == cart_two[1] + 1 && cart[2] == ">" && cart_two[2] == "<"
      return "#{cart[1]},#{cart[0]}" if cart[0] == cart_two[0] && cart[1] == cart_two[1] - 1 && cart[2] == "<" && cart_two[2] == ">"
    end
  end
end

def cart_at carts, y, x
  carts.each do |cart|
    next if @dead_indexes.include?(cart[4])
    return cart if cart[0] == y && cart[1] == x
  end
  nil
end

def sort_carts carts
  carts.sort_by { |cart| [cart[0], cart[1]] }
end

def print_with_carts grid, carts
  grid.each_with_index do |row, y|
    row.each_with_index do |char, x|
      if (cart = cart_at(carts, y, x))
        if @dead_indexes.include?(cart[4])
          print char
        else
          print cart[2]
        end
      else
        print char
      end
    end
    puts
  end
end
@dead_indexes = Set.new

carts = sort_carts(carts)

turn = ['l', 's', 'r']
while !collided_carts(carts)
  carts.each do |cart|
    y, x, dir, t = cart
    if dir == "<"
      x -= 1
      if grid[y][x] == "/"
        dir = "v"
      elsif grid[y][x] == "\\"
        dir = "^"
      elsif grid[y][x] == "+"
        if turn[t] == "l"
          dir = "v"
        elsif turn[t] == "r"
          dir = "^"
        end
        t = (t + 1) % 3
      end
    elsif dir == ">"
      x += 1
      if grid[y][x] == "/"
        dir = "^"
      elsif grid[y][x] == "\\"
        dir = "v"
      elsif grid[y][x] == "+"
        if turn[t] == "l"
          dir = "^"
        elsif turn[t] == "r"
          dir = "v"
        end
        t = (t + 1) % 3
      end
    elsif dir == "^"
      y -= 1
      if grid[y][x] == "/"
        dir = ">"
      elsif grid[y][x] == "\\"
        dir = "<"
      elsif grid[y][x] == "+"
        if turn[t] == "l"
          dir = "<"
        elsif turn[t] == "r"
          dir = ">"
        end
        t = (t + 1) % 3
      end
    elsif dir == "v"
      y += 1
      if grid[y][x] == "/"
        dir = "<"
      elsif grid[y][x] == "\\"
        dir = ">"
      elsif grid[y][x] == "+"
        if turn[t] == "l"
          dir = ">"
        elsif turn[t] == "r"
          dir = "<"
        end
        t = (t + 1) % 3
      end
    end
    cart[0] = y
    cart[1] = x
    cart[2] = dir
    cart[3] = t
  end
end
puts collision_location(carts)

# Part 2

lines = IO.readlines(ARGV[0])
carts = []
grid = new_grid lines.length, lines[0].length
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    if char == "<"
      carts << [y, x, "<", 0, carts.length]
    elsif char == ">"
      carts << [y, x, ">", 0, carts.length]
    elsif char == "^"
      carts << [y, x, "^", 0, carts.length]
    elsif char == "v"
      carts << [y, x, "v", 0, carts.length]
    end
    if char == "<" || char == ">"
      grid[y][x] = "-"
    elsif char == "^" || char == "v"
      grid[y][x] = "|"
    else
      grid[y][x] = char
    end
  end
end

round = 1
total_carts = carts.length
@dead_indexes = Set.new
while @dead_indexes.length < total_carts - 1
  carts = sort_carts(carts)
  carts.each do |cart|
    y, x, dir, t, index = cart
    next if @dead_indexes.include?(index)
    if dir == "<"
      x -= 1
      if grid[y][x] == "/"
        dir = "v"
      elsif grid[y][x] == "\\"
        dir = "^"
      elsif grid[y][x] == "+"
        if turn[t] == "l"
          dir = "v"
        elsif turn[t] == "r"
          dir = "^"
        end
        t = (t + 1) % 3
      end
    elsif dir == ">"
      x += 1
      if grid[y][x] == "/"
        dir = "^"
      elsif grid[y][x] == "\\"
        dir = "v"
      elsif grid[y][x] == "+"
        if turn[t] == "l"
          dir = "^"
        elsif turn[t] == "r"
          dir = "v"
        end
        t = (t + 1) % 3
      end
    elsif dir == "^"
      y -= 1
      if grid[y][x] == "/"
        dir = ">"
      elsif grid[y][x] == "\\"
        dir = "<"
      elsif grid[y][x] == "+"
        if turn[t] == "l"
          dir = "<"
        elsif turn[t] == "r"
          dir = ">"
        end
        t = (t + 1) % 3
      end
    elsif dir == "v"
      y += 1
      if grid[y][x] == "/"
        dir = "<"
      elsif grid[y][x] == "\\"
        dir = ">"
      elsif grid[y][x] == "+"
        if turn[t] == "l"
          dir = ">"
        elsif turn[t] == "r"
          dir = "<"
        end
        t = (t + 1) % 3
      end
    end
    if (collision = cart_at(carts, y, x))
      @dead_indexes << collision[4]
      @dead_indexes << index
    else
      cart[0] = y
      cart[1] = x
      cart[2] = dir
      cart[3] = t
    end
  end
  @dead_indexes.each do |index|
    carts.delete_if { |cart| cart[4] == index }
  end
  # print_with_carts(grid, carts)
  # key_wait
  round += 1
end

@dead_indexes.each do |index|
  carts.delete_if { |cart| cart[4] == index }
end

raise "Oh crap we messed up" if carts.length != 1

puts carts[0][1].to_s + "," + carts[0][0].to_s

# y, x, dir, t, index = carts[0]

# if dir == "<"
#   x -= 1
# elsif dir == ">"
#   x += 1
# elsif dir == "^"
#   y -= 1
# elsif dir == "v"
#   y += 1
# end

# puts x.to_s + "," + y.to_s
# wrong
# 43, 44
# 43, 43
# 4, 49
# 5, 49
# 98, 83
# 73, 119
# 86, 39
# 87, 39
# 86, 38
# 111, 136
# 112, 136
