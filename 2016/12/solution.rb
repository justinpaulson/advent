require '../../grid.rb'
ARGV[0] ||= "input"
instructions = IO.readlines(ARGV[0]).map(&:chomp).map{|line| line.split(" ")}


registers = {
  "a" => 0,
  "b" => 0,
  #"c" => 0, # part 1
  "c" => 1,
  "d" => 0
}

cursor = 0

while (instruction = instructions[cursor])
  case instruction[0]
  when "cpy"
    if instruction[1].match(/[a-d]/)
      registers[instruction[2]] = registers[instruction[1]]
    else
      registers[instruction[2]] = instruction[1].to_i
    end
  when "inc"
    registers[instruction[1]] += 1
  when "dec"
    registers[instruction[1]] -= 1
  when "jnz"
    if registers[instruction[1]] != 0
      cursor += instruction[2].to_i
      next
    end
  end
  cursor += 1
end

puts registers["a"]
