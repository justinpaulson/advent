require '../../grid.rb'

ARGV[0] ||= "input"

lines = IO.read(ARGV[0]).chomp.split(",")
boxes = Array.new(256) { Array.new()}
lines.each do |line|
  box = 0
  operator_index = line.index(/\-|\=/)
  operator = line[operator_index]
  value = line[operator_index+1..-1].to_i
  label = line[0..operator_index-1]
  label.chars.each do |c|
    box += c.ord
    box *= 17
    box = box % 256
  end

  puts "checking line #{line} for box #{box} operator #{operator} label #{label} value #{value}"

  if operator == "-"
    boxes[box].delete_at(boxes[box].index{|b| b["label"] == label}) if boxes[box].index{|b| b["label"] == label}
  else
    if boxes[box].index{|b| b["label"] == label}
      boxes[box][boxes[box].index{|b| b["label"] == label}]["value"] = value
    else
      boxes[box] << {"label" => label, "value" => value}
    end
  end
end

total = 0

boxes.each_with_index do |box, index|
  box.each_with_index do |b, slot|
    total += b["value"] * (index + 1) * (slot + 1)
  end
end

# puts boxes.to_s

puts total


# nope
# 5619689472
