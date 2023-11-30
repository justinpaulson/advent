class Node
  attr_accessor :parent, :nodes, :name, :weight
  def initialize(name, nodes, weight)
    @nodes = nodes
    @name = name
    @weight = weight
    @parent = nil
  end
end

lines = File.readlines("input")

nodes = []

lines.each do |line|
  name_num, children = line.chomp.split(" -> ")
  name = name_num.split[0]
  num = name_num.split("(")[1].to_i
  children = children&.split(", ")
  children = children&.map do |kid|
    kid_node = nodes.find{|n| n.name == kid}
    unless kid_node
      kid_node = Node.new(kid, [], 0)
      nodes << kid_node
    end
    kid_node.parent = name
    kid_node
  end
  node = nodes.find{|n| n.name == name}
  unless node
    node = Node.new(name, [])
    nodes << node
  end
  node.nodes = children
  node.weight = num
end

puts nodes.to_s

puts nodes.select{|n| n.parent == nil}.map(&:name)

nodes.select{|n| n.nodes = nil}