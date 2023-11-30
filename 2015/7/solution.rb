# &	Bitwise AND
# |	Bitwise OR
# ^	Bitwise XOR
# ~	Bitwise NOT
# <<	Bitwise left shift
# >> Bitwise right shift

lines = File.readlines("input")

wires = {}

lines.each do |line|
  code, wire = line.chomp.split(" -> ")
  code = code.gsub("NOT ", "~")
  code = code.gsub(" AND ", "&")
  code = code.gsub(" OR ", "|")
  code = code.gsub(" LSHIFT ", "<<")
  code = code.gsub(" RSHIFT ", ">>")
  wires[wire] = code
end

puts wires.to_s

wire_values = {}

while wire_values.length != wires.length
  wires.each do |wire, code|
    begin
      ready = true
      code.scan(/[a-z]+/) do |var|
        ready = false unless wire_values[var]
      end
      next unless ready
      puts code if wire == "t"
      code.scan(/[a-z]+/){|rep| code = code.gsub(rep, wire_values[rep].to_s)}
      puts code if wire == "t"
      wire_values[wire] = eval(code)
    rescue TypeError => e
      puts "we got here dammit" if wire == "t"
      raise e if wire == "t"
    end
  end
  puts wire_values.to_s
end

puts wire_values.to_s

puts wire_values["a"]

wires["b"] = wire_values["a"].to_s

wire_values = {}

while wire_values.length != wires.length
  wires.each do |wire, code|
    begin
      ready = true
      code.scan(/[a-z]+/) do |var|
        ready = false unless wire_values[var]
      end
      next unless ready
      puts code if wire == "t"
      code.scan(/[a-z]+/){|rep| code = code.gsub(rep, wire_values[rep].to_s)}
      puts code if wire == "t"
      wire_values[wire] = eval(code)
    rescue TypeError => e
      puts "we got here dammit" if wire == "t"
      raise e if wire == "t"
    end
  end
  puts wire_values.to_s
end

puts wire_values.to_s

puts wire_values["a"]