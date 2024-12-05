require '../../grid.rb'
ARGV[0] ||= "input"

rules, orders = IO.read(ARGV[0]).split("\n\n")

orders = orders.split("\n").map{|o| o.split(",").map(&:to_i)}

@pages = {}

rules.split("\n").each do |rule|
  pre, post = rule.split("|").map(&:to_i)
  @pages[post] ||= []
  @pages[post] << pre
end

def valid? order
  order[0..-2].each_with_index do |o, i|
    invalids = @pages[o] || []
    invalids.each do |inv|
      if order[i..-1].include?(inv)
        return false
      end
    end
  end
  return true
end

invalids = []
total = 0
orders.each do |order|
  if valid?(order)
    total += order[order.length/2]
  else
    invalids << order
  end
end

puts total

def make_valid order
  updated_order = order.dup
  updated_order[0..-2].each_with_index do |o1, i|
    invalids = @pages[o1] || []
    updated_order[i+1..-1].each_with_index do |o2, j|
      index = j + i + 1
      if invalids.include?(o2)
        updated_order[index], updated_order[i] = updated_order[i], updated_order[index]
      end
    end
  end
  while !valid?(updated_order)
    updated_order = make_valid(updated_order)
  end
  return updated_order
end

total = 0
invalids.each do |order|
  o = make_valid(order)
  total += o[o.length/2]
end

puts total
