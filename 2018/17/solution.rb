require '../../grid.rb'
ARGV[0] ||= "input"
ARGV[1] ||= 500
starting_x = ARGV[1].to_i
lines = IO.readlines(ARGV[0]).map(&:chomp)

if lines[0].to_i.to_s == lines[0].chomp
  starting_x = lines.shift.to_i
end

min_y = lines.map do |line|
  line.split(', ').map do |part|
    if part[0]=='y'
      part.split('=')[1].split('..').map(&:to_i).min
    else
      999
    end
  end.min
end.min

max_y = lines.map do |line|
  line.split(', ').map do |part|
    if part[0]=='y'
      part.split('=')[1].split('..').map(&:to_i).max
    else
      0
    end
  end.max
end.max

max_x = lines.map do |line|
  line.split(', ').map do |part|
    if part[0]=='x'
      part.split('=')[1].split('..').map(&:to_i).max
    else
      0
    end
  end.max
end.max

min_x = lines.map do |line|
  line.split(', ').map do |part|
    if part[0]=='x'
      part.split('=')[1].split('..').map(&:to_i).min
    else
      685
    end
  end.min
end.min

grid = new_grid max_y+1, max_x-min_x+4

lines.each do |line|
  first, second = line.split(', ')
  first = first.split('=')
  if first[0]=='x'
    x = first[1].to_i
    miy = second.split('=')[1].split('..')[0].to_i
    may = second.split('=')[1].split('..')[1].to_i
    miy.upto(may) do |y|
      grid[y][x-min_x+2] = '#'
    end
  else
    y = first[1].to_i
    mix = second.split('=')[1].split('..')[0].to_i
    maxx = second.split('=')[1].split('..')[1].to_i
    mix.upto(maxx) do |x|
      grid[y][x-min_x+2] = '#'
    end
  end
end

drops = [[0,starting_x-min_x+2,'|']]

while drops.count > 0
  new_drops = []
  drops.each do |drop|
    y = drop[0]
    x = drop[1]
    next if grid[y][x] == '|' && drop[2] == '|'
    grid[y][x] = drop[2]
    case drop[2]
    when '|'
      if y+1 < grid.length && grid[y+1][x] == '.'
        new_drops << [y+1,x,'|']
      elsif y+1 < grid.length && grid[y+1][x] == '#'
        new_drops << [y,x,'~']
      elsif y+1 < grid.length && grid[y+1][x] == '~'
        new_drops << [y+1,x,'~']
      end
    when '~'
      if grid[y+1][x] == '.' || grid[y+1][x] == '|'
        new_drops << [y+1,x,'|']
        next
      end
      back_x = x-1
      while back_x >= 0 && grid[y][back_x] == '~'
        back_x -= 1
      end
      back_x += 1
      front_x = x+1
      while front_x < grid[y].length && grid[y][front_x] == '~'
        front_x += 1
      end
      front_x -= 1
      if grid[y][x+1] == '~' && grid[y][x-1] == '~'
        if grid[y-1][back_x..front_x].include?('|') && grid[y][front_x+1] == '#' && grid[y][back_x-1] == '#'
          unless grid[y+1][back_x..front_x].include?('|') || grid[y+1][back_x..front_x].include?('.')
            grid[y-1][back_x..front_x].each_index.select{|i| grid[y-1][i+back_x] == '|'}.each do |ix|
              new_drops << [y-1,ix + back_x,'~']
            end
          end
        end
        next
      end
      if grid[y][x+1] == '.' || grid[y][x-1] == '.' || grid[y][x+1] == '|' || grid[y][x-1] == '|'
        new_drops << [y,x+1,'~'] if grid[y][x+1] == '.' || grid[y][x+1] == '|'
        new_drops << [y,x-1,'~'] if grid[y][x-1] == '.' || grid[y][x-1] == '|'
        next
      end
      if grid[y-1][x] == '~'
        if grid[y-1][x-1] == '.'
          new_drops << [y-1,x-1,'~']
        elsif grid[y-1][x+1] == '.'
          new_drops << [y-1,x+1,'~']
        end
        next
      end
      if grid[y][x+1] == '#'
        if grid[y][back_x-1] == '#' && grid[y-1][back_x..x].include?('|')
          unless grid[y+1][back_x..x].include?('|') || grid[y+1][back_x..x].include?('.')
            grid[y-1][back_x..x].each_index.select{|i| grid[y-1][i+back_x] == '|'}.each do |ix|
              new_drops << [y-1,ix + back_x,'~']
            end
          end
        elsif grid[y][back_x-1] == '.' && grid[y+1][back_x] != '|' && grid[y+1][back_x] != '.' && grid[y+1][back_x] != '|'
          new_drops << [y,back_x-1,'~']
        elsif grid[y][back_x-1] == '#'
          new_drops << [y-1,x,'~']
        end
        next
      end
      if grid[y][x+1] == '~'
        if grid[y][x-1] == '.'
          new_drops << [y,x-1,'~']
          next
        end
        if grid[y][x-1] == '#'
          if grid[y][front_x+1] == '#' && grid[y-1][x..front_x].include?('|')
            unless grid[y+1][x..front_x].include?('|') || grid[y+1][x..front_x].include?('.')
              grid[y-1][x..front_x].each_index.select{|i| grid[y-1][i+x] == '|'}.each do |ix|
                new_drops << [y-1,ix + x,'~']
              end
            end
          elsif grid[y][front_x+1] == '.' && grid[y+1][front_x] != '|'
            new_drops << [y,front_x+1,'~']
          elsif grid[y][front_x+1] == '#'
            new_drops << [y-1,x,'~']
          end
        end
      end
    end
  end
  drops = new_drops.uniq

  if new_drops.count > 0
    average_y = [drops.map{|d| d[0]}.ave || 0, 20].max
    range = [average_y-20,average_y+20]

    print_grid(grid[range[0]..range[1]])
    # puts new_drops.to_s
    # if average_y > 1580
    #   key_wait
    # end
  end
end

puts grid[min_y..-1].map{|r| r.map{|c| c == '~' || c == '|' ? 1 : 0}.sum}.sum

total = 0
grid.each_cons(2).each do |row1, row2|
  row1.each_index do |i|
    if row1[i] == '~'
      front_x = i - 1
      while front_x >= 0 && row1[front_x] == '~'
        front_x -= 1
      end
      front_x += 1

      back_x = i + 1
      while back_x < row1.length && row1[back_x] == '~'
        back_x += 1
      end
      back_x -= 1

      total += 1 unless row2[front_x..back_x].include?('|')
    end
  end
end

puts total
