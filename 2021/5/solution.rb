load "../../grid.rb"
lines = File.readlines("input")

squares = lines.map{|l| l.split(" -> ")}.map{|st, en| [st.split(',').map(&:to_i), en.split(',').map(&:to_i)]}

grid = new_grid 1000, 1000, 0

squares.each do |start, e|
  x1,y1 = start
  x2,y2 = e
  next unless y1 == y2 || x1 == x2
  if y1 == y2
    if x1 < x2
      x1.upto(x2) do |x|
        grid[x][y1] += 1
      end
    else
      x1.downto(x2) do |x|
        grid[x][y1] += 1
      end
    end
  else
    if y1 < y2
      y1.upto(y2) do |y|
        grid[x1][y] += 1
      end
    else
      y1.downto(y2) do |y|
        grid[x1][y] += 1
      end
    end
  end
end

p grid.sum{|line| line.sum{|c| c > 1 ? 1 : 0}}

grid = new_grid 1000, 1000, 0

squares.each do |start, e|
  x1,y1 = start
  x2,y2 = e
  if x1 < x2
    if y1 < y2
      x1.upto(x2).each_with_index do |x, i|
        grid[x][y1+i] += 1
      end
    elsif y1 == y2
      x1.upto(x2) do |x|
        grid[x][y1] += 1
      end
    else
      x1.upto(x2).each_with_index do |x, i|
        grid[x][y1-i] += 1
      end
    end
  elsif x1 == x2
    if y1 < y2
      y1.upto(y2) do |y|
        grid[x1][y] += 1
      end
    else
      y1.downto(y2) do |y|
        grid[x1][y] += 1
      end
    end
  elsif y1 < y2
    x1.downto(x2).each_with_index do |x, i|
      grid[x][y1+i] += 1
    end
  elsif y1 == y2
    if x1 < x2
      x1.upto(x2) do |x|
        grid[x][y1] += 1
      end
    else
      x1.downto(x2) do |x|
        grid[x][y1] += 1
      end
    end
  else
    x1.downto(x2).each_with_index do |x, i|
      grid[x][y1 - i] += 1
    end
  end
end

p grid.sum{|line| line.sum{|c| c > 1 ? 1 : 0}}