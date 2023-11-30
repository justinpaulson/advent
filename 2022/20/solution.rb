lines = IO.readlines("input").map(&:to_i)

output = lines.clone

# puts lines.count

# puts output.uniq.count
# puts lines.uniq.count

@length = lines.length

class Node
  attr_accessor :next_node, :prev_node, :value

  def initialize(value, length)
    @value = value
    @length = length
  end

  def move
    moves = @value < 0 ? ((@length - 1) + @value % (@length-1)) : @value % (@length - 1)
    puts "Moving #{moves} times"
    moves.times do |i|
      @prev_node.next_node = @next_node
      @next_node.prev_node = @prev_node
      @prev_node = @next_node
      # puts next_node.next_node
      # puts next_node
      # puts next_node.next_node.next_node
      temp_node = @next_node.next_node
      @next_node = temp_node
      @prev_node.next_node = self 
      @next_node.prev_node = self
    end
  end

  def to_s
    "Next: #{@next_node&.value}, Prev: #{@prev_node&.value}, value: #{@value}"
  end
end

nodes = []

lines.each do |l|
  i = Node.new(l * 811589153, @length)
  if nodes.length > 0
    nodes[-1].next_node = i
    i.prev_node = nodes[-1]
  end
  # puts nodes[-1]
  nodes << i
end

nodes[0].next_node = nodes[1]
nodes[0].prev_node = nodes[-1]
nodes[-1].next_node = nodes[0]
nodes[1].prev_node = nodes[0]
nodes[1].next_node = nodes[2]

# nodes.each do |n|
#   puts n
# end

10.times do 
  nodes.each do |node|
    node.move
  end
end

zero_node = nodes.select{|n| n.value == 0}[0]

node = zero_node
1000.times{|i| node = node.next_node}
thousand  = node
node = zero_node
2000.times{|i| node = node.next_node}
two_thousand = node
node = zero_node
3000.times{|i| node = node.next_node}
three_thousand = node

puts thousand.value + two_thousand.value + three_thousand.value

# 13778349050481 too high