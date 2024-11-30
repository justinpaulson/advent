require '../../grid.rb'
ARGV[0] ||= "input"

instructions = IO.readlines(ARGV[0]).map(&:chomp).map{|line| line.split(" ")}


registers = {
  # "a" => 7, # part 1
  "a" => 12, # part 2
  "b" => 0,
  "c" => 0,
  "d" => 0
}

cursor = 0

# SLOW for part 2, but works!
while (instruction = instructions[cursor])
  case instruction[0]
  when "cpy"
    if instruction[2].match(/[a-d]/)
      if instruction[1].match(/[a-d]/)
        registers[instruction[2]] = registers[instruction[1]]
      else
        registers[instruction[2]] = instruction[1].to_i
      end
    end
  when "inc"
    registers[instruction[1]] += 1
  when "dec"
    registers[instruction[1]] -= 1
  when "jnz"
    if registers[instruction[1]] != 0
      if instruction[2].to_i.to_s == instruction[2]
        cursor += instruction[2].to_i - 1
      else
        cursor += registers[instruction[2]] - 1
      end
    end
  when "tgl"
    target = cursor + registers[instruction[1]]
    if target_instruction = instructions[target]
      case target_instruction[0]
      when "cpy"
        target_instruction[0] = "jnz"
      when "jnz"
        target_instruction[0] = "cpy"
      when "inc"
        target_instruction[0] = "dec"
      when "dec"
        target_instruction[0] = "inc"
      when "tgl"
        target_instruction[0] = "inc"
      end
    end
  end
  cursor += 1
end

puts registers["a"]


# Part 2 Rainbow table so to speak :D These values can help speed it up a bit
#    665280
# 665280
# {"a"=>665280, "b"=>7, "c"=>1, "d"=>1}
# [["cpy", "a", "b"], ["dec", "b"], ["cpy", "a", "d"], ["cpy", "0", "a"], ["cpy", "b", "c"], ["inc", "a"], ["dec", "c"], ["jnz", "c", "-2"], ["dec", "d"], ["jnz", "d", "-5"], ["dec", "b"], ["cpy", "b", "c"], ["cpy", "c", "d"], ["dec", "d"], ["inc", "c"], ["jnz", "d", "-2"], ["tgl", "c"], ["cpy", "-16", "c"], ["jnz", "1", "c"], ["cpy", "85", "c"], ["jnz", "92", "d"], ["inc", "a"], ["inc", "d"], ["jnz", "d", "-2"], ["inc", "c"], ["jnz", "c", "-5"]]
# cursor = 6
# * 6
#   3991680
# {"a"=>3991680, "b"=>6, "c"=>1, "d"=>1}
# [["cpy", "a", "b"], ["dec", "b"], ["cpy", "a", "d"], ["cpy", "0", "a"], ["cpy", "b", "c"], ["inc", "a"], ["dec", "c"], ["jnz", "c", "-2"], ["dec", "d"], ["jnz", "d", "-5"], ["dec", "b"], ["cpy", "b", "c"], ["cpy", "c", "d"], ["dec", "d"], ["inc", "c"], ["jnz", "d", "-2"], ["tgl", "c"], ["cpy", "-16", "c"], ["jnz", "1", "c"], ["cpy", "85", "c"], ["jnz", "92", "d"], ["inc", "a"], ["inc", "d"], ["jnz", "d", "-2"], ["inc", "c"], ["jnz", "c", "-5"]]
# cursor = 6
# * 5
#  19958400
# 19958400
# {"a"=>19958400, "b"=>5, "c"=>1, "d"=>1}
# [["cpy", "a", "b"], ["dec", "b"], ["cpy", "a", "d"], ["cpy", "0", "a"], ["cpy", "b", "c"], ["inc", "a"], ["dec", "c"], ["jnz", "c", "-2"], ["dec", "d"], ["jnz", "d", "-5"], ["dec", "b"], ["cpy", "b", "c"], ["cpy", "c", "d"], ["dec", "d"], ["inc", "c"], ["jnz", "d", "-2"], ["tgl", "c"], ["cpy", "-16", "c"], ["jnz", "1", "c"], ["cpy", "85", "c"], ["jnz", "92", "d"], ["inc", "a"], ["inc", "d"], ["jnz", "d", "-2"], ["inc", "c"], ["jnz", "c", "-5"]]
# cursor = 6
# * 4
#  79833600
# * 3
# 239500800
# 239500800
# {"a"=>239500800, "b"=>3, "c"=>1, "d"=>1}
# [["cpy", "a", "b"], ["dec", "b"], ["cpy", "a", "d"], ["cpy", "0", "a"], ["cpy", "b", "c"], ["inc", "a"], ["dec", "c"], ["jnz", "c", "-2"], ["dec", "d"], ["jnz", "d", "-5"], ["dec", "b"], ["cpy", "b", "c"], ["cpy", "c", "d"], ["dec", "d"], ["inc", "c"], ["jnz", "d", "-2"], ["tgl", "c"], ["cpy", "-16", "c"], ["jnz", "1", "c"], ["cpy", "85", "c"], ["jnz", "92", "d"], ["inc", "a"], ["dec", "d"], ["jnz", "d", "-2"], ["dec", "c"], ["jnz", "c", "-5"]]
# cursor = 6
# * 2
# 479001600
# {"a"=>479001600, "b"=>2, "c"=>1, "d"=>1}
# [["cpy", "a", "b"], ["dec", "b"], ["cpy", "a", "d"], ["cpy", "0", "a"], ["cpy", "b", "c"], ["inc", "a"], ["dec", "c"], ["jnz", "c", "-2"], ["dec", "d"], ["jnz", "d", "-5"], ["dec", "b"], ["cpy", "b", "c"], ["cpy", "c", "d"], ["dec", "d"], ["inc", "c"], ["jnz", "d", "-2"], ["tgl", "c"], ["cpy", "-16", "c"], ["jnz", "1", "c"], ["cpy", "85", "c"], ["cpy", "92", "d"], ["inc", "a"], ["dec", "d"], ["jnz", "d", "-2"], ["dec", "c"], ["jnz", "c", "-5"]]
# cursor = 6
#
# Run a few more iterations for answer....
