require '../../grid.rb'
ARGV[0] ||= "input"

@instructions = IO.readlines(ARGV[0]).map(&:chomp).map{|line| line.split(" ")}


registers = {
  "a" => 4,
  "b" => 0,
  "c" => 0,
  "d" => 0
}

cursor = 0

# SLOW for part 2, but works!
0.upto(10000) do |a|
  registers["a"] = a
  registers["b"] = 0
  registers["c"] = 0
  registers["d"] = 0
  count = 0
  output = ""
  cursor = 0
  while (instruction = @instructions[cursor]) && count < 100000
    count += 1
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
      if instruction[1].to_i.to_s == instruction[1]
        if instruction[1].to_i != 0
          if instruction[2].to_i.to_s == instruction[2]
            cursor += instruction[2].to_i - 1
          else
            cursor += registers[instruction[2]] - 1
          end
        end
      elsif registers[instruction[1]] != 0
        if instruction[2].to_i.to_s == instruction[2]
          cursor += instruction[2].to_i - 1
        else
          cursor += registers[instruction[2]] - 1
        end
      end
    when "out"
      out_value = instruction[1].match(/[a-d]/) ? registers[instruction[1]] : instruction[1].to_i
      output << out_value.to_s
    end
    cursor += 1
  end
  if output[0..7]=="01010101"
    puts a
    exit
  end
end
