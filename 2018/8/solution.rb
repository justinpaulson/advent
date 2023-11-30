class Node
  attr_accessor :nodes, :entries

  def initialize(nodes=[],entries=[])
    @nodes = nodes
    @entries = entries
  end

  def node_array
    [@nodes.count, @entries.count] + @nodes.map(&:node_array) + @entries
  end

end

lines = IO.read("test").split.map(&:to_i)

nodes = []

def get_child_nodes(nodes, lines, children)
  child_nodes = []
  puts lines.to_s
  0.upto(children-01).map do |i|
    p child_nodes.map{|n| n.node_array.count}.sum
    lines = lines[child_nodes[i-1].node_array.count..-1] if i > 0
    puts lines.to_s
    child_count = lines[0]
    metadata_count = lines[1]
    if child_count == 0
      node = Node.new([],lines[2..metadata_count+1])
      nodes << node
      child_nodes << node
      lines = lines[2+metadata_count..-1]
      node
    else
      puts lines.to_s
      node = Node.new(get_child_nodes(nodes, lines[2..-1], child_count))
      lines = lines[node.node_array.length-1..-1]
      node.entries = lines[-metadata_count..-1]
      nodes << node
      child_nodes << node
      node
    end
  end
end

while lines.length > 0
  child_count = lines[0]
  metadata_count = lines[1]
  metadata = lines[-metadata_count..-1]
  puts lines[2..-metadata_count-1].to_s
  nodes << Node.new(get_child_nodes(nodes, lines[2..-metadata_count-1], child_count))
end
puts lines.to_s

# ans=0

# puts ans


# # 2 3 1 3 1 1 0 1 99 2 10 11 12 0 1 5 1 1 2
# # A----------------------------------------
# #     B------------------------ E----
# #         C-----------
# #             D-----

# lines = 1 3 1 1 0 1 99 2 10 11 12 0 1 5 1
# children = 2
# i = 1
# child_count = 1
# metadata_count = 3
# node = 
#   lines = 1 1 0 1 99 2 10 11 12 0 1 5 1
#   children = 1
#   i = 1
#   child_count = 1
#   metadata_count = 1
#   node.children =
#     lines = 0 1 99 2 10 11 12 0 1 5 1
#     children = 1
#     i = 1
#     child_count = 0
#     metadata_count = 1
#     node.children = []
#     node.meta = [99]
#   node.meta = 

# # 2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
# # A----------------------------------
# #     B----------- C-----------
# #                      D-----
