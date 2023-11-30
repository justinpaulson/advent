lines = IO.readlines("input").map{|l| l.chomp.split(",").map(&:to_i)}

lines = [
  [1,4,2,3,14,2,7],
  [2,2,3,3,8,3,12]
]

lines = [
  [1,4,4,3,11,3,8],
  [2,4,4,4,14,3,16],
  [3,3,3,2,15,3,9]
].reverse

maxs = [ 31, 11, 40].reverse

@max_geodes = 0

def total_geodes minutes, robots, resources
  ore_robots, clay_robots, obsidian_robots, geode_robots = robots
  ore, clay, obs, geode = resources
  
  # puts "Minute: #{minutes}"
  # puts robots.to_s
  # puts resources.to_s

  if minutes >= 32
    if geode > @max_geodes
      @max_geodes = geode
      puts "Found a path with new max geodes: #{geode}"
      puts robots.to_s
      puts resources.to_s
    end
    return geode
  end

  test_geode = geode
  test_geode += geode_robots + 0.upto(32-minutes).sum

  return 0 if test_geode < @max_geodes

  minutes += 1

  next_ore = ore + ore_robots
  next_clay = clay + clay_robots
  next_obs = obs + obsidian_robots
  next_geode = geode + geode_robots

  branches = []


  # ore_cost = 4
  # clay_cost = 4
  # obs_cost_ore = 4
  # obs_cost_clay = 8
  # ge_cost_ore = 3
  # ge_cost_obs = 19

  if @geode_cost_obs <= obs && @geode_cost_ore <= ore
    branches << [[ ore_robots, clay_robots, obsidian_robots, geode_robots + 1 ],[ next_ore - @geode_cost_ore, next_clay, next_obs - @geode_cost_obs, next_geode ]]
  else

    if @obs_cost_ore <= ore && @obs_cost_clay <= clay
      branches << [[ ore_robots, clay_robots, obsidian_robots + 1, geode_robots ],[ next_ore - @obs_cost_ore, next_clay - @obs_cost_clay, next_obs, next_geode ]]
    end

    if @ore_cost <= ore
      branches << [[ ore_robots + 1, clay_robots, obsidian_robots, geode_robots ],[ next_ore - @ore_cost, next_clay, next_obs, next_geode ]]
    end

    if @clay_cost <= ore
      branches << [[ ore_robots, clay_robots + 1, obsidian_robots, geode_robots ],[ next_ore - @clay_cost, next_clay, next_obs, next_geode ]]
    end

    branches << [[ ore_robots, clay_robots, obsidian_robots, geode_robots ],[ next_ore, next_clay, next_obs, next_geode ]]
  end

  return branches.map{|(robots, resources)| total_geodes minutes, robots, resources }.max
end

totals = lines.each_with_index.map do |line, i|
  @blueprint, @ore_cost, @clay_cost, @obs_cost_ore, @obs_cost_clay, @geode_cost_ore, @geode_cost_obs = line
  @max_geodes = maxs[i] - 1
  total = total_geodes(0, [1,0,0,0], [0,0,0,0])
  puts "#{@blueprint}: #{total}"
  total
end

puts totals.to_s
puts totals[0] * totals[1] * totals[2]

#  1:   31  !!
#  2:   11  !!
#  3:   40  !!

# 7440 too low
# 13640

# 1*2+
# 2*0+
# 3*4+
# 4*4+
# 5*0+
# 6*1+
# 7*3+
# 8*5+
# 9*0+
# 10*0+
# 11*0+
# 12*0+
# 13*1+
# 14*0+
# 15*2+
# 16*2+
# 17*1+
# 18*3+
# 19*1+
# 20*4+
# 21*5+
# 22*8+
# 23*3+
# 24*3+
# 25*0+
# 26*5+
# 27*0+
# 28*9+
# 29*2+
# 30*3