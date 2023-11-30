comms = IO.readlines("test").map do |l|
  ranges = l.split("#{l.split(' ')[0]} ")[1].chomp
  x_range = ranges.split(",")[0].split("=")[1].split("..").map(&:to_i)
  y_range = ranges.split(",")[1].split("=")[1].split("..").map(&:to_i)
  z_range = ranges.split(",")[2].split("=")[1].split("..").map(&:to_i)
  [l.split(" ")[0]] + x_range + y_range + z_range
end

grid = Array.new(100) { Array.new(100) { Array.new(100) { 0 } } }

# comms = comms[0..9]

comms.each do |comm|
  act=comm[0]
  x_min = [[comm[1], -50].max,50].min
  x_max = [[comm[2], 50].min,-50].max
  y_min = [[comm[3], -50].max,50].min
  y_max = [[comm[4], 50].min,-50].max
  z_min = [[comm[5], -50].max,50].min
  z_max = [[comm[6], 50].min,-50].max

  if x_min!=x_max && y_min!=y_max && z_min!=z_max
    x_min.upto(x_max) do |x|
      y_min.upto(y_max) do |y|
        z_min.upto(z_max) do |z|
          grid[x][y][z] = act == "on" ? 1 : 0
        end
      end
    end
  end
end

def overlaps comms, comm
  _, x_min, x_max, y_min, y_max, z_min, z_max = comm
  
  laps = []
  
  comms.each do |check|
    next if comm == check
    _, c_x_min, c_x_max, c_y_min, c_y_max, c_z_min, c_z_max = check
    if 
      x_min <= c_x_max && x_max >= c_x_min &&
      y_min <= c_y_max && y_max >= c_y_min &&
      z_min <= c_z_max && z_max >= c_z_min
      laps << check
    end
  end
  
  laps
end

def has_overlap? comms, comm
  overlaps(comms, comm).length > 0
end

def cut_rects target, cutter
  _, x_min, x_max, y_min, y_max, z_min, z_max = target
  _, x_c_min, x_c_max, y_c_min, y_c_max, z_c_min, z_c_max = cutter
  [
    ["on", x_min, [x_min, x_c_min].max, y_min, [y_min, y_c_min].max, z_min, [z_min, z_c_min].max],
    ["on", x_min, [x_min, x_c_min].max, y_min, [y_min, y_c_min].max, [z_min, z_c_min].max, [z_max, z_c_max].min],
    ["on", x_min, [x_min, x_c_min].max, y_min, [y_min, y_c_min].max, [z_max, z_c_max].min, z_max],
    ["on", x_min, [x_min, x_c_min].max, [y_min, y_c_min].max, [y_max, y_c_max].min, z_min, [z_min, z_c_min].max],
    ["on", x_min, [x_min, x_c_min].max, [y_min, y_c_min].max, [y_max, y_c_max].min, [z_min, z_c_min].max, [z_max, z_c_max].min],
    ["on", x_min, [x_min, x_c_min].max, [y_min, y_c_min].max, [y_max, y_c_max].min, [z_max, z_c_max].min, z_max],
    ["on", x_min, [x_min, x_c_min].max, [y_max, y_c_max].min, y_max, z_min, [z_min, z_c_min].max],
    ["on", x_min, [x_min, x_c_min].max, [y_max, y_c_max].min, y_max, [z_min, z_c_min].max, [z_max, z_c_max].min],
    ["on", x_min, [x_min, x_c_min].max, [y_max, y_c_max].min, y_max, [z_max, z_c_max].min, z_max],

    ["on", [x_min, x_c_min].max, [x_max, x_c_max].min, y_min, [y_min, y_c_min].max, z_min, [z_min, z_c_min].max],
    ["on", [x_min, x_c_min].max, [x_max, x_c_max].min, y_min, [y_min, y_c_min].max, [z_min, z_c_min].max, [z_max, z_c_max].min],
    ["on", [x_min, x_c_min].max, [x_max, x_c_max].min, y_min, [y_min, y_c_min].max, [z_max, z_c_max].min, z_max],
    ["on", [x_min, x_c_min].max, [x_max, x_c_max].min, [y_min, y_c_min].max, [y_max, y_c_max].min, z_min, [z_min, z_c_min].max],
    ["on", [x_min, x_c_min].max, [x_max, x_c_max].min, [y_min, y_c_min].max, [y_max, y_c_max].min, [z_max, z_c_max].min, z_max],
    ["on", [x_min, x_c_min].max, [x_max, x_c_max].min, [y_max, y_c_max].min, y_max, z_min, [z_min, z_c_min].max],
    ["on", [x_min, x_c_min].max, [x_max, x_c_max].min, [y_max, y_c_max].min, y_max, [z_min, z_c_min].max, [z_max, z_c_max].min],
    ["on", [x_min, x_c_min].max, [x_max, x_c_max].min, [y_max, y_c_max].min, y_max, [z_max, z_c_max].min, z_max],

    ["on", [x_c_max, x_max].min, x_max, y_min, [y_min, y_c_min].max, z_min, [z_min, z_c_min].max],
    ["on", [x_c_max, x_max].min, x_max, y_min, [y_min, y_c_min].max, [z_min, z_c_min].max, [z_max, z_c_max].min],
    ["on", [x_c_max, x_max].min, x_max, y_min, [y_min, y_c_min].max, [z_max, z_c_max].min, z_max],
    ["on", [x_c_max, x_max].min, x_max, [y_min, y_c_min].max, [y_max, y_c_max].min, z_min, [z_min, z_c_min].max],
    ["on", [x_c_max, x_max].min, x_max, [y_min, y_c_min].max, [y_max, y_c_max].min, [z_min, z_c_min].max, [z_max, z_c_max].min],
    ["on", [x_c_max, x_max].min, x_max, [y_min, y_c_min].max, [y_max, y_c_max].min, [z_max, z_c_max].min, z_max],
    ["on", [x_c_max, x_max].min, x_max, [y_max, y_c_max].min, y_max, z_min, [z_min, z_c_min].max],
    ["on", [x_c_max, x_max].min, x_max, [y_max, y_c_max].min, y_max, [z_min, z_c_min].max, [z_max, z_c_max].min],
    ["on", [x_c_max, x_max].min, x_max, [y_max, y_c_max].min, y_max, [z_max, z_c_max].min, z_max],
  ].select{|_,a,b,c,d,e,f| a!=b && c!=d && e!=f }
end

p grid.sum{|l| l.sum{|c| c.sum}}

grid = {}
on_rects = []

comms = comms.map do |comm|
  a, x, x1, y, y1, z, z1 = comm
  [a, x-1, x1, y-1, y1, z-1, z1]
end

comms.each do |comm|
  act, x_min, x_max, y_min, y_max, z_min, z_max = comm

  # puts "Checking rect: "
  # puts comm.to_s
  # puts "against: "
  # puts on_rects.to_s
  (on_rects << comm.clone if act=="on"; next) unless has_overlap?(on_rects, comm)
  # puts "had overlaps"

  cut_cubes = overlaps(on_rects, comm)

  # puts "cut cubes"
  # puts cut_cubes.to_s
  # puts "on rects"
  # puts on_rects.to_s

  cut_cubes.each do |c|
    # update c to cut out the overlap
    on_rects.delete(c)
    on_rects += cut_rects(c, comm)
  end
  # puts "on after cuts"
  # puts on_rects.to_s
  on_rects << comm.clone if act == "on"
end


p on_rects.sum{|_,a,b,c,d,e,f| (b-a) * (d-c) * (f-e)}

# 28725439866810242 too high

# 2758514936282235
# 2758481072261743