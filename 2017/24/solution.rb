require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

components = {}
component_map = {}

lines.each do |line|
  a, b = line.split("/").map(&:to_i)
  component_map[a] ||= []
  component_map[b] ||= []
  component_map[a] << b
  component_map[b] << a
  components[[a, b].sort] ||= 0
  components[[a, b].sort] += 1
end

def compnent_used(path, component)
  path.each_cons(2).any?{|a, b| [a, b].sort == [path[-1],component].sort}
end

strongest = 0

queue = [[0]]

longest = { }

while path = queue.pop
  last = path.last
  component_map[last].each do |component|
    next if compnent_used(path, component)
    queue << path + [component]
  end
  strength = path[0..-2].sum{|a| a * 2} + path[-1]
  longest[path.length - 1] ||= 0
  if longest[path.length - 1] < strength
    longest[path.length - 1] = strength
  end
end

puts longest.values.max

puts longest.max_by{|k, v| k}[1]
