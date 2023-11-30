load "../../grid.rb"

lines = IO.readlines("input").map(&:chomp)

class Node
  attr_accessor :name, :nodes
  def initialize (name, nodes=[])
    @name = name
    @nodes = nodes
  end

  def to_s
    "#{@name}-#{@nodes.map(&:name).join(',')}"
  end

  def big?
    @name.match?(/[A-Z]/)
  end

  def add_node node
    @nodes << node
    @nodes = @nodes.uniq
  end
end

nodes = []

lines.each do |line|
  name, dest = line.split("-")
  child = nodes.find{|n| n.name == dest} || Node.new(dest)
  node = nodes.find{|n| n.name == name} || Node.new(name, [child])
  child.add_node(node)
  node.add_node(child)
  nodes << node
  nodes << child
  nodes = nodes.uniq
end

nodes.each do |n|
  puts "#{n.name} - Big: #{n.big?}"
end

def count_end_paths path, nodes, node
  # puts path.to_s
  # puts path.map(&:name).join(",")
  return 0 if path.length > 1 && node.name == "start"
  if node.name == "end"
    # puts "found an end!"
    puts (path.map(&:name)+["end"]).join(",")
    return 1
  end
  node.nodes.sum do |child|
    # puts child.to_s
    if (path.include?(child) && !child.big?)
      0
    else
      # puts child.to_s
      count_end_paths(path + [node], nodes, child)
    end
  end
end

def has_dupe_littles path
  g = []
  path.each do |n|
    if !n.big?
      g << n.name
    end
  end
  g.length != g.uniq.length
end

def count_end_paths_2 path, nodes, node
  return 0 if path.length > 1 && node.name == "start"
  if node.name == "end"
    return 1
  end
  node.nodes.sum do |child|
    if !child.big? && path.include?(child) && has_dupe_littles(path + [node])
      0
    else
      count_end_paths_2(path + [node], nodes, child)
    end
  end
end

start = nodes.find{|n| n.name == "start"}

p count_end_paths [], nodes, start

p count_end_paths_2 [], nodes, start


# 10029 wrong

# 173245 too high