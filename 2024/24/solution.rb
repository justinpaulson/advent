require '../../grid.rb'
ARGV[0] ||= "input"
values, connections = IO.read(ARGV[0]).split("\n\n")

@all_wires = []
@set_wires = {}
values.split("\n").each do |line|
  wire, value = line.split(": ")
  @all_wires << wire
  @all_wires.uniq!
  @set_wires[wire] = value.to_i
end

connects = {}
connections.split("\n").each do |line|
  ws, connect = line.split(" -> ")
  @all_wires << connect
  first, arg, second = ws.split(" ")
  arg = case arg
  when "AND"
    "&"
  when "OR"
    "|"
  when "XOR"
    "^"
  end
  connects[connect] = [first, arg, second]
  @all_wires << first
  @all_wires << second
  @all_wires.uniq!
end

@all_wires.sort!
@zs = {}

@all_wires.each do |wire|
  if wire[0] == 'z'
    @zs[wire] = false
  end
end

while @zs.any?{|k,v| !v}
  connects.each do |connect, args|
    next if @set_wires.keys.include?(connect)
    first, arg, second = args
    next unless @set_wires.keys.include?(first) && @set_wires.keys.include?(second)

    @set_wires[connect] = eval("#{@set_wires[first]} #{arg} #{@set_wires[second]}")
    if connect.start_with?("z")
      @zs[connect] = true
    end
  end
end

def get_output wires
  out = ""
  wires.keys.sort.reverse.each do |wire_key|
    wire_val = wires[wire_key]
    out << wire_val.to_s
  end
  out.to_i(2)
end

puts get_output(@set_wires.select{|k,_| k[0] == 'z'})

bad_wires = {
  "z35" => "hqk",
  "z06" => "fhc",
  "z11" => "qhj",
  "ggt" => "mwh"
}

bad_wires.each do |wire, value|
  connects[wire], connects[value] = connects[value], connects[wire]
end

def get_parents wires, wire
  parents = []
  first, arg, second = wires[wire]
  # puts "Checking: #{first} and #{second}"
  # puts "add to parents? First: #{first[0] == 'y' || first[0] == 'x'} Second: #{second[0] == 'y' || second[0] == 'x'}"
  if first[0] == 'y' || first[0] == 'x' || second[0] == 'y' || second[0] == 'x'
    parents << "#{first} #{arg} #{second}"
  else
    parents += get_parents(wires, first)
    parents += get_parents(wires, second)
  end
  parents
end

@set_wires.keys.select{|k| k[0] == 'z'}.each do |wire|
  # puts "Getting parents for wire: #{wire}"
  parents = get_parents(connects, wire)
  wire_num = wire[1..2].to_i
  _, arg, _ = connects[wire]
  # puts "Immediate parent was not XOR for #{wire}" if arg != "^"
  # puts "BADDIEEEEE" if parents.count != 2 * wire[1..2].to_i
  # puts "Parents: #{parents}"
  ands = {}
  xors = {}
  parents.each do |parent|
    ands[parent[1..2].to_i] = true if parent[4] == "&"
    xors[parent[1..2].to_i] = true if parent[4] == "^"
  end
  # puts ands.keys.sort.join(",")
  # puts xors.keys.sort.join(",")
  # if ands.keys != ands.keys.uniq
  #   puts "WE GOT PROBLEMS HERE!!! ANDS"
  # end
  # if xors.keys != xors.keys.uniq
  #   puts "WE GOT PROBLEMS HERE!!! XORS"
  # end
end

def output_2 wires
  wires.sort.join(",")
end

#found bad wires by hand!!

puts output_2(bad_wires.keys + bad_wires.values)
