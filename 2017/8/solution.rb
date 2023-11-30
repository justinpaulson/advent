lines = File.readlines("input")

registers = {}

high = 0

lines.each do |line|
  change, cond = line.chomp.split(" if ")
  name, dir, value = change.split
  value = value.to_i
  target, qual, qual_val = cond.split
  qual_val = qual_val.to_i
  registers[name] ||= 0
  registers[target] ||= 0
  case qual
  when ">"
    if registers[target] > qual_val
      if dir == "inc"
        registers[name] += value
      else
        registers[name] -= value
      end
    end
  when "<"
    if registers[target] < qual_val
      if dir == "inc"
        registers[name] += value
      else
        registers[name] -= value
      end
    end
  when ">="
    if registers[target] >= qual_val
      if dir == "inc"
        registers[name] += value
      else
        registers[name] -= value
      end
    end
  when "<="
    if registers[target] <= qual_val
      if dir == "inc"
        registers[name] += value
      else
        registers[name] -= value
      end
    end
  when "=="
    if registers[target] == qual_val
      if dir == "inc"
        registers[name] += value
      else
        registers[name] -= value
      end
    end
  when "!="
    if registers[target] != qual_val
      if dir == "inc"
        registers[name] += value
      else
        registers[name] -= value
      end
    end
  end
  high = registers[name] if registers[name] > high
end

puts registers.values.max
puts high