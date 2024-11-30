class Node
  attr_accessor :parent, :nodes, :name, :weight
  def initialize(name, nodes, weight)
    @nodes = nodes
    @name = name
    @weight = weight
    @parent = nil
  end

  def disc_weight
    return weight if nodes == nil
    weight + nodes.map(&:disc_weight).sum
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
    kid_node
  end
  node = nodes.find{|n| n.name == name}
  unless node
    node = Node.new(name, [], num)
    nodes << node
  end
  node.nodes = children
  node.weight = num
  children&.each{|c| c.parent = node}
end

puts nodes.select{|n| n.parent == nil}.map(&:name)

bad_nodes = []
bad_node_weights = []
nodes.each do |node|
  if node.nodes != nil
    weights = {}
    node.nodes.each{|n| weights[n] = n.disc_weight}
    weight = weights.values.max_by{|v| weights.values.count(v)}
    0.upto(node.nodes.length - 1).each do |i|
      n = node.nodes[i]
      if n.disc_weight != weight
        if n.nodes.map(&:disc_weight).uniq.length == 1
          bad_nodes << n
          bad_node_weights << weight
        end
      end
    end
  end
end

bad_nodes.each_with_index do |bad_node, i|
  bad_node_weight = bad_node_weights[i]
  puts bad_node_weight - bad_node.nodes.sum{|n| n.disc_weight}
end
