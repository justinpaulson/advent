require '../../grid.rb'
ARGV[0] ||= "input"
commands = IO.readlines(ARGV[0]).map(&:chomp).map do |comm|
  command = comm.split(" ")[0]
  args = comm.split(" ")[1..-1]
  [command, args]
end

registers = {
  "a" => 0,
  "b" => 0,
  "c" => 0,
  "d" => 0,
  "e" => 0,
  "f" => 0,
  "g" => 0,
  "h" => 0
}

cursor = 0

sounds = []
count = 0
while cursor < commands.length
  command, args = commands[cursor]
  case command
  when "set"
    registers[args[0]] = args[1].match(/\d+/) ? args[1].to_i : registers[args[1]]
  when "sub"
    registers[args[0]] -= args[1].match(/\d+/) ? args[1].to_i : registers[args[1]]
  when "mul"
    count += 1
    registers[args[0]] *= args[1].match(/\d+/) ? args[1].to_i : registers[args[1]]
  when "jnz"
    if (args[0].match(/\d+/) ? args[0].to_i : registers[args[0]]) != 0
      cursor += args[1].match(/\d+/) ? args[1].to_i : registers[args[1]]
      next
    end
  end
  cursor += 1
end

puts count

# Part 2: see solution2.rb
