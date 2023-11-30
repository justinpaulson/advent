require 'pry'

scanners = {}
IO.read("input").split("\n\n").map{|s| name,*sats = s.split("\n"); scanners[name.split('nner ')[1].split(' --')[0]] = sats.map{|s| s.split(",").map(&:to_i)}.sort}

diffs_x = scanners.map{|s,v| v.each_cons(2).map{|a,b| b[0] - a[0]}}
diffs_y = scanners.map{|s,v| v.each_cons(2).map{|a,b| b[1] - a[1]}}
diffs_z = scanners.map{|s,v| v.each_cons(2).map{|a,b| b[2] - a[2]}}

def distance a, b
  (b[0] - a[0]).abs**2 + (b[1] - a[1]).abs**2 + (b[2] - a[2]).abs**2
end

def flip_and_rotate points, flip, rotation
  new_points = []
  points.each do |point|
    new_point = flip.each_with_index.map{|flip, i| point[i] * flip}
    new_points << rotation.map{|index| new_point[index]}
  end
  new_points
end

beacons = []

scanners["0"].each do |beacon|
  beacons << beacon
end
beacon_diffs = {}

scanners.delete("0")

offsets = []

while scanners.size > 0
  max = 0
  max_scan = "0"
  0.upto(beacons.length-1) do |a_index|
    0.upto(beacons.length-1) do |b_index|
      next if a_index == b_index
      next if beacon_diffs[[a_index, b_index].sort]

      beacon_diffs[[a_index, b_index].sort] = distance(beacons[a_index], beacons[b_index])
    end
  end
  
  scanners.each do |s, new_beacons|
    next if s == "6"
    new_beacon_distances = new_beacons.permutation(2).map {|a,b| distance a, b}
    (max_scan = s; max = (beacon_diffs.values & new_beacon_distances).count) if (beacon_diffs.values & new_beacon_distances).count > max
  end

  puts "Closest scanner is #{max_scan}"
  puts "Finding orientation...."

  new_diffs = {}

  beacon_indexes = []
  sb_indexes = []
  0.upto(scanners[max_scan].length-1) do |a_index|
    0.upto(scanners[max_scan].length-1) do |b_index|
      next if a_index == b_index
      next if new_diffs[[a_index, b_index].sort]

      found_diff = beacon_diffs.find{|indexes, diff| diff == distance(scanners[max_scan][a_index], scanners[max_scan][b_index])}
      if found_diff
        sb_indexes += [a_index, b_index]
        sb_indexes = sb_indexes.flatten.uniq.compact
        beacon_indexes += found_diff[0]
        beacon_indexes = beacon_indexes.flatten.uniq.compact
      end
    end
  end

  index_1 = 1
  index_2 = 2

  correct_flip = nil

  while !correct_flip
    index_1 += 1
    index_2 += 1

    beacon_1 = beacons[beacon_indexes[index_1]]
    beacon_2 = beacons[beacon_indexes[index_2]]
    
    binding.pry if index_2 > sb_indexes.length-1

    test_1 = scanners[max_scan][sb_indexes[index_1]]
    test_2 = scanners[max_scan][sb_indexes[index_2]]
    
    puts [beacon_1, beacon_2].to_s
    puts [test_1, test_2].to_s
    
    known_beacons = beacon_indexes.map {|i| beacons[i] }
    puts known_beacons.to_s
    
    test_beacons = sb_indexes.map {|i| scanners[max_scan][i] }
    puts test_beacons.to_s
    
    b_diffs = [beacon_2[0]-beacon_1[0],beacon_2[1]-beacon_1[1],beacon_2[2]-beacon_1[2]]
    
    test_diffs = [test_2[0] - test_1[0], test_2[1] - test_1[1], test_2[2] - test_1[2]]
    
    flip_matrix = [
      [1, 1, 1],
      [-1, 1, 1],
      [1, -1, 1],
      [1, 1, -1],
      [-1, -1, 1],
      [1, -1, -1],
      [-1, 1, -1],
      [-1, -1, -1]
    ]
    
    correct_flip = flip_matrix.select{|x,y,z| b_diffs.sum == test_diffs[0]*x + test_diffs[1]*y + test_diffs[2]*z}[0]
  end

  binding.pry unless correct_flip

  test_diffs = test_diffs.each_with_index.map{|a,i| correct_flip[i] * a}

  rotation_matrix = [
    [0,1,2],
    [0,2,1],
    [1,0,2],
    [1,2,0],
    [2,0,1],
    [2,1,0]
  ]

  correct_rotation = rotation_matrix.select{|a,b,c| b_diffs == [test_diffs[a], test_diffs[b], test_diffs[c]]}.first

  puts correct_flip.to_s
  puts correct_rotation.to_s

  puts scanners[max_scan].to_s

  # binding.pry

  corrected_scanner = flip_and_rotate scanners[max_scan], correct_flip, correct_rotation

  puts "Found flip and rotation, now finding offset..."


  puts corrected_scanner.to_s

  test_1 = corrected_scanner[sb_indexes[index_1]]
  test_2 = corrected_scanner[sb_indexes[index_2]]

  x_offset = beacon_1[0] - test_1[0]
  y_offset = beacon_1[1] - test_1[1]
  z_offset = beacon_1[2] - test_1[2]

  offsets << [x_offset, y_offset, z_offset]

  puts offsets.permutation(2).map{|a,b| (b[0]-a[0]).abs + (b[1]-a[1]).abs + (b[2]-a[2]).abs}.max

  puts t=beacons.count

  puts "adding beacons"
  corrected_scanner.each do |x, y, z|
    beacons << [x + x_offset, y + y_offset, z + z_offset]
  end
 
  beacons = beacons.uniq
  puts beacons.count
  puts beacons.count - t

  scanners.delete(max_scan)
end

#  295 - too low
#  310 - too low
#  315 - right!
#  316 - wrong
#  317 - wrong
#  318 - wrong
#  319 - wrong
#  320 - wrong
#  325 - too high


# 8526 too low