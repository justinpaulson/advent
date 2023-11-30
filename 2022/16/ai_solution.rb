# Parse the input and create a graph data structure to represent the valve network
def create_graph(input)
  graph = {}
  input.each_line do |line|
    parts = line.split(" ")
    valve = parts[1]
    flow_rate = parts[4].delete("rate=").delete(";").to_i
    tunnels = parts[9..-1].map { |v| v.delete(",") }
    graph[valve] = { flow_rate: flow_rate, tunnels: tunnels }
  end
  graph
end

# Depth-first search function to find the path that leads to the maximum pressure release
def dfs(graph, valve, elapsed_time)
  # Calculate the current pressure release
  pressure_release = elapsed_time * graph[valve][:flow_rate]

  # If the elapsed time is greater than or equal to 30 minutes, return the current pressure release
  return pressure_release if elapsed_time >= 30

  # Initialize the maximum pressure release
  max_pressure_release = 0

  # Iterate over the adjacent valves and recursively call the DFS function for each of them
  graph[valve][:tunnels].each do |adjacent_valve|
    max_pressure_release = [max_pressure_release, dfs(graph, adjacent_valve, elapsed_time + 1)].max
  end

  # Return the maximum pressure release
  max_pressure_release
end

# Example input
input = <<~INPUT
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
INPUT

# Create the graph
graph = create_graph(input)

puts graph.to_s

# Start the DFS function at valve AA with an elapsed time of zero
max_pressure_release = dfs(graph, "AA", 0)

puts "The maximum pressure release is #{max_pressure_release}"