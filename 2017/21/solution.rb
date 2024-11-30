require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
patterns = {}

lines.each do |line|
  key, value = line.split(" => ")
  key = key.split("/").map(&:chars)
  grid = new_grid(key.length, key.length)
  key.each_with_index do |row, y|
    row.each_with_index do |char, x|
      grid[y][x] = char
    end
  end

  value = value.split("/").map(&:chars)
  target = new_grid(value.length, value.length)
  value.each_with_index do |row, y|
    row.each_with_index do |char, x|
      target[y][x] = char
    end
  end

  patterns[grid] = target
  patterns[grid.transpose.reverse] = target
  grid = grid.transpose.reverse
  patterns[grid.transpose.reverse] = target
  grid = grid.transpose.reverse
  patterns[grid.transpose.reverse] = target
  grid = grid.transpose.reverse
  patterns[grid.reverse] = target
  grid = grid.reverse
  patterns[grid.transpose.reverse] = target
  grid = grid.transpose.reverse
  patterns[grid.transpose.reverse] = target
  grid = grid.transpose.reverse
  patterns[grid.transpose.reverse] = target
  grid = grid.transpose.reverse
end


picture = new_grid(3,3)
picture[0] = ".#.".chars
picture[1] = "..#".chars
picture[2] = "###".chars

18.times do |i|
  if picture.length % 2 == 0
    new_picture = new_grid(picture.length/2*3, picture.length/2*3)
    0.upto(picture.length/2-1) do |y|
      0.upto(picture.length/2-1) do |x|
        grid = new_grid(2,2)
        grid[0] = picture[y*2][x*2..x*2+1]
        grid[1] = picture[y*2+1][x*2..x*2+1]
        out_grid = patterns[grid]
        new_picture[y*3][x*3..x*3+2] = out_grid[0]
        new_picture[y*3+1][x*3..x*3+2] = out_grid[1]
        new_picture[y*3+2][x*3..x*3+2] = out_grid[2]
      end
    end
  else
    new_picture = new_grid(picture.length/3*4, picture.length/3*4)
    0.upto(picture.length/3-1) do |y|
      0.upto(picture.length/3-1) do |x|
        grid = new_grid(3,3)
        grid[0] = picture[y*3][x*3..x*3+2]
        grid[1] = picture[y*3+1][x*3..x*3+2]
        grid[2] = picture[y*3+2][x*3..x*3+2]
        out_grid = patterns[grid]
        new_picture[y*4][x*4..x*4+3] = out_grid[0]
        new_picture[y*4+1][x*4..x*4+3] = out_grid[1]
        new_picture[y*4+2][x*4..x*4+3] = out_grid[2]
        new_picture[y*4+3][x*4..x*4+3] = out_grid[3]
      end
    end
  end
  picture = new_picture
  puts picture.flatten.count("#") if i == 4
end

puts picture.flatten.count("#")
