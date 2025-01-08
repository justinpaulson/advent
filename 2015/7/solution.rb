ARGV[0] ||= "input"
# &	Bitwise AND
# |	Bitwise OR
# ^	Bitwise XOR
# ~	Bitwise NOT
# <<	Bitwise left shift
# >> Bitwise right shift

lines = File.readlines(ARGV[0])

wires = {}

lines.each do |line|
  code, wire = line.chomp.split(" -> ")
  code = code.gsub("NOT ", "~").gsub(" AND ", "&").gsub(" OR ", "|")
    .gsub(" LSHIFT ", "<<").gsub(" RSHIFT ", ">>")
  wires[wire] = code
end

wire_values = {}

while wire_values.length != wires.length
  wires.each do |wire, code|
    begin
      ready = true
      code.scan(/[a-z]+/) do |var|
        ready = false unless wire_values[var]
      end
      next unless ready
      code.scan(/[a-z]+/){|rep| code = code.gsub(rep, wire_values[rep].to_s)}
      wire_values[wire] = eval(code)
    rescue TypeError => e
      raise e if wire == "t"
    end
  end
end

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
      code.scan(/[a-z]+/){|rep| code = code.gsub(rep, wire_values[rep].to_s)}
      wire_values[wire] = eval(code)
    rescue TypeError => e
      raise e if wire == "t"
    end
  end
end

puts wire_values["a"]
