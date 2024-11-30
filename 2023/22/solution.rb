require '../../grid.rb'
ARGV[0] ||= "input"
bricks = IO.readlines(ARGV[0]).map(&:chomp).map do |line|
  front, back = line.split("~").map{|x| x.split(",").map(&:to_i)}
end

def drop_brick brick
  brick[0][2] -= 1
  brick[1][2] -= 1
end

def collapse_bricks bricks
  grid = {}
  bricks.each do |brick|
    front = brick[0]
    back = brick[1]
    front[0].upto(back[0]) do |x|
      front[1].upto(back[1]) do |y|
        front[2].upto(back[2]) do |z|
          grid[[x,y,z]] = "#"
        end
      end
    end
  end

  bricks.each do |brick|
    front = brick[0]
    back = brick[1]
    front[0].upto(back[0]) do |x|
      front[1].upto(back[1]) do |y|
        front[2].upto(back[2]) do |z|
          grid[[x,y,z]] = "."
        end
      end
    end
    x = 0
    y = 0
    z = [front[2], back[2]].min
    points = []
    if front[2] != back[2]
      points << [front[0], front[1]]
    else
      xs = [front[0], back[0]].sort
      ys = [front[1], back[1]].sort
      xs[0].upto(xs[1]) do |x|
        ys[0].upto(ys[1]) do |y|
          points << [x,y]
        end
      end
    end
    while !points.any?{|p| grid[[p[0],p[1],[brick[0][2],brick[1][2]].min - 1]] == "#"} && [brick[0][2],brick[1][2]].min > 0
      drop_brick brick
    end

    front = brick[0]
    back = brick[1]
    front[0].upto(back[0]) do |x|
      front[1].upto(back[1]) do |y|
        front[2].upto(back[2]) do |z|
          grid[[x,y,z]] = "#"
        end
      end
    end
  end

  bricks
end

total = {}

@original_bricks = bricks.sort {|a,b| [a[0][2],a[1][2]].min <=> [b[0][2],b[1][2]].min}
@initial_collapse = collapse_bricks deep_copy(@original_bricks)

falls = 0
0.upto(@original_bricks.length-1) do |i|
  disintegrate = true
  collapsed = i > 0 ? @initial_collapse[0..i-1] + @initial_collapse[i+1..-1] : @initial_collapse[1..-1]
  new_bricks = deep_copy(i > 0 ? @initial_collapse[0..i-1] + @initial_collapse[i+1..-1] : @initial_collapse[1..-1])
  new_bricks = collapse_bricks new_bricks
  new_bricks.each_with_index do |(front,back),i|
    if collapsed[i] != [front,back]
      falls += 1
      disintegrate = false
    end
  end
  if disintegrate
    total[i] ||= 0
    total[i] += 1
  end
end

puts total.keys.count
puts falls
