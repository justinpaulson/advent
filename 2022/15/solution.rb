require "../../grid"

lines = IO.readlines("input")

lines = lines.map do |line|
  sensor, beacon = line.split(": closest beacon is at x=")
  sensor = sensor.split("ensor at x=")[1]
  sensor = sensor.split(", y=").map(&:to_i)
  beacon = beacon.split(", y=").map(&:to_i)
  range = (sensor[0]-beacon[0]).abs + (sensor[1]-beacon[1]).abs
  [sensor, range]
end

sensors = []
beacons = []
max_x = 0
min_x = 99999999
max_y = 0
min_y = 99999999
max_range = 0

max_row = 4000000

start_row = ARGV[0].to_i || 0

2634249.downto(0) do |row|
  puts row

  grid = Array.new(max_row + 1) { true }

  lines.each do |(sensor, range)|
    if sensor[1] - range <= row && sensor[1] + range >= row
      x_dist = range - (row-sensor[1]).abs
      min_pos = [sensor[0]-x_dist, 0].max
      max_pos = [sensor[0]+x_dist, max_row].min
      grid[min_pos..max_pos] = Array.new(max_pos-min_pos+1, false)
    end
  end

  if grid.find_index(true)
    puts "We found it!"
    puts [row, grid.find_index(true)]
    puts grid.find_index(true) * 4000000 + row
    exit
  end
end

