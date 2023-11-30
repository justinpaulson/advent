lines = IO.readlines("input")

@rates = {}
@paths = {}
@nodes = ["AA"]
lines.each do |line|
  line = line.chomp
  valve, rate = line.split(" has flow rate=")
  valve = valve.split("Valve ")[-1]
  to_valves = []
  if rate.match(/tunnels/)
    rate, to_valves = rate.split("; tunnels lead to valves ")
    rate = rate.to_i
    to_valves = to_valves.split(", ")
  else
    rate, to_valve = rate.split("; tunnel leads to valve ")
    rate = rate.to_i
    to_valves = [to_valve]
  end
  @rates[valve] = rate
  @nodes << valve if rate > 0
  @paths[valve] = to_valves
end

@nodes = @nodes.sort{|a,b| @rates[a] <=> @rates[b]}.reverse

@max = 0
@max_moves = -1
@valves = @rates.keys
@checked = 0

def distance from_node, to_node
  d = 0
  found = [from_node]
  while !found.include?(to_node)
    d += 1
    found = found.map{|node| @paths[node]}.flatten
  end
  d
end

@dist = {}

@nodes.each do |a|
  @dist[a] ||= {}
end

@nodes.each do |a|
  @dist[a][a] = 0
end

@nodes.combination(2) do |u,v|
  d = distance(u,v)
  @dist[u][v] = d
  @dist[v][u] = d
end

def max_flow_2 current, open_valves, moves, max_moves, pressure_total, path
  if moves >= max_moves
    if pressure_total > @max
      @max = pressure_total
      puts "New max: #{@max}"
      puts path.to_s
    end
    return pressure_total
  end

  # puts path.to_s

  branches = []

  @nodes.select{|n| path.count(n) < 1 && n != current && !open_valves.include?(n)}.each do |n|
    unless @dist[current][n] >= max_moves - moves
      if !open_valves.include?(current) && current != "AA"
        branches << [n, open_valves + [current], moves + 1 + @dist[current][n], pressure_total + @rates[current] * (30 - moves - 1), path + [n]]
      else
        branches << [n, open_valves, moves + @dist[current][n], pressure_total, path + [n]]
      end
    end
  end

  if branches.empty?
    if !open_valves.include?(current)
      pressure_total += (max_moves - moves - 1) * @rates[current]
    end
    if pressure_total > @max
      @max = pressure_total
      puts "New max: #{@max}"
      puts path.to_s
    end
    return pressure_total
  end

  return branches.map{|(c, o, m, pt, pa)| max_flow_2(c, o, m, max_moves, pt, pa)}.max
end

@max = 0
@total_branchs = 0
moves = 0
total = 0
open_valves = []

# part 1
# max_moves = 30
# current = "AA"
# path = ["AA"]
# puts max_flow_2(current, open_valves, moves, max_moves, total, path)

@all_maxes = {}

def calc_path path, max_moves
  total_time = 0
  @all_maxes[path] ||= 1.upto(path.length-1).map do |i|
      curr = path[i]
      prev = path[i-1]
      total_time += @dist[prev][curr] + 1
      (max_moves - total_time) * @rates[curr]
    end.sum
  @all_maxes[path]
end

def remaining open_valves
  @nodes - open_valves
end

def max_flow_3 current, open_valves, moves, max_moves, path
  puts @total_branchs if @total_branchs % 100000 == true

  pressure_total = calc_path(path[0], max_moves) + calc_path(path[1], max_moves)

  test_total = 0.upto(7-path[0].length-1).map do |i|
    v = remaining(open_valves)[i]
    [@rates[v] * (max_moves - moves[0] - 1 - @dist[current[0]][v]), 0].max
  end.sum

  test_total += 0.upto(7-path[1].length-1).map do |i|
    v = remaining(open_valves)[i]
    [@rates[v] * (max_moves - moves[1] - 1 - @dist[current[1]][v]), 0].max
  end.sum

  return 0 if pressure_total + test_total < @max

  if moves[0] >= max_moves && moves[1] >= max_moves
    @total_branchs += 1
    if pressure_total > @max
      @max = pressure_total
      puts "New max: #{@max}"
      puts path.to_s
      puts @total_branchs
    end
    return pressure_total
  end

  branches = []

  @nodes.select{|n| path[0].count(n) < 1 && path[1].count(n) < 1 && n != current[0] && n != current[1] && !open_valves.include?(n)}.each do |n|
    unless @dist[current[0]][n] + 1 >= max_moves - moves[0]
      if !open_valves.include?(current[0]) && current[0] != "AA"
        branches << [[n, current[1]], open_valves + [current[0]], [moves[0] + 1 + @dist[current[0]][n], moves[1]], [path[0] + [n], path[1]]]
      end
    end
    unless @dist[current[1]][n] + 1 >= max_moves - moves[1]
      if !open_valves.include?(current[1]) && current[1] != "AA"
        branches << [[current[0], n], open_valves + [current[1]], [moves[0], moves[1] + 1 + @dist[current[1]][n]], [path[0], path[1] + [n]]]
      end
    end
    if current[0] == "AA"
      branches << [[n, current[1]], open_valves, [moves[0] + @dist[current[0]][n], moves[1]], [path[0] + [n], path[1]]]
    end
    if current[1] == "AA"
      branches << [[current[0], n], open_valves, [moves[0], moves[1] + @dist[current[1]][n]], [path[0], path[1] + [n]]]
    end
  end

  if branches.empty?
    @total_branchs += 1
    if pressure_total > @max
      @max = pressure_total
      puts "New max: #{@max}"
      puts path.to_s
      puts @total_branchs
    end
    return pressure_total
  end

  return branches.map{|(c, o, m, pa)| max_flow_3(c, o, m, max_moves, pa)}.max
end

@max = 0
max_moves = 26
path = [["AA"], ["AA"]]
current = ["AA", "AA"]
moves = [0, 0]

puts max_flow_3 current, open_valves, moves, max_moves, path

# 1885 wrong, too low
# 2024 wrong, too low
# 2112 wrong, too low
