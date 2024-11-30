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
  "i" => 0,
  "p" => 0,
  "f" => 0
}

cursor = 0

sounds = []
while cursor < commands.length
  command, args = commands[cursor]
  case command
  when "snd"
    sounds << registers[args[0]]
  when "set"
    registers[args[0]] = args[1].match(/\d+/) ? args[1].to_i : registers[args[1]]
  when "add"
    registers[args[0]] += args[1].match(/\d+/) ? args[1].to_i : registers[args[1]]
  when "mul"
    registers[args[0]] *= args[1].match(/\d+/) ? args[1].to_i : registers[args[1]]
  when "mod"
    registers[args[0]] %= args[1].match(/\d+/) ? args[1].to_i : registers[args[1]]
  when "rcv"
    if registers[args[0]] != 0
      puts sounds.last
      break
    end
  when "jgz"
    if (args[0].match(/\d+/) ? args[0].to_i : registers[args[0]]) > 0
      cursor += args[1].match(/\d+/) ? args[1].to_i : registers[args[1]]
      next
    end
  end
  cursor += 1
end

registers_1 = {
  "a" => 0,
  "b" => 0,
  "i" => 0,
  "p" => 1,
  "f" => 0
}

registers_2 = {
  "a" => 0,
  "b" => 0,
  "i" => 0,
  "p" => 0,
  "f" => 0
}

cursor_1 = 0
cursor_2 = 0

queue_1 = []
queue_2 = []
send_count = 0
while cursor_1 < commands.length && cursor_2 < commands.length
  command_1, args_1 = commands[cursor_1]
  command_2, args_2 = commands[cursor_2]
  next_1 = false
  next_2 = false
  case command_1
  when "snd"
    send_count += 1
    queue_2 << registers_1[args_1[0]]
  when "set"
    registers_1[args_1[0]] = args_1[1].match(/\d+/) ? args_1[1].to_i : registers_1[args_1[1]]
  when "add"
    registers_1[args_1[0]] += args_1[1].match(/\d+/) ? args_1[1].to_i : registers_1[args_1[1]]
  when "mul"
    registers_1[args_1[0]] *= args_1[1].match(/\d+/) ? args_1[1].to_i : registers_1[args_1[1]]
  when "mod"
    registers_1[args_1[0]] %= args_1[1].match(/\d+/) ? args_1[1].to_i : registers_1[args_1[1]]
  when "rcv"
    if queue_1.length == 0
      next_1 = true
    else
      registers_1[args_1[0]] = queue_1.shift
    end
  when "jgz"
    if (args_1[0].match(/\d+/) ? args_1[0].to_i : registers_1[args_1[0]]) > 0
      cursor_1 += args_1[1].match(/\d+/) ? args_1[1].to_i : registers_1[args_1[1]]
      next_1 = true
    end
  end
  case command_2
  when "snd"
    queue_1 << registers_2[args_2[0]]
  when "set"
    registers_2[args_2[0]] = args_2[1].match(/\d+/) ? args_2[1].to_i : registers_2[args_2[1]]
  when "add"
    registers_2[args_2[0]] += args_2[1].match(/\d+/) ? args_2[1].to_i : registers_2[args_2[1]]
  when "mul"
    registers_2[args_2[0]] *= args_2[1].match(/\d+/) ? args_2[1].to_i : registers_2[args_2[1]]
  when "mod"
    registers_2[args_2[0]] %= args_2[1].match(/\d+/) ? args_2[1].to_i : registers_2[args_2[1]]
  when "rcv"
    if queue_2.length == 0
      next_2 = true
    else
      registers_2[args_2[0]] = queue_2.shift
    end
  when "jgz"
    if (args_2[0].match(/\d+/) ? args_2[0].to_i : registers_2[args_2[0]]) > 0
      cursor_2 += args_2[1].match(/\d+/) ? args_2[1].to_i : registers_2[args_2[1]]
      next_2 = true
    end
  end
  break if queue_1.length == 0 && queue_2.length == 0 && next_1 && next_2 && command_1 == "rcv" && command_2 == "rcv"
  cursor_1 += 1 unless next_1
  cursor_2 += 1 unless next_2
end

puts send_count
