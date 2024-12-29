require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

@ip_register = lines[0].chomp
@ip_register = @ip_register.split(" ")[1].to_i

code = lines[1..-1].map(&:chomp).map{|l| l.split(" ").each_with_index.map{|v, i| i == 0 ? v : v.to_i}}

def addr(registers, a, b, c)
  registers[c] = registers[a] + registers[b]
  registers
end

def addi(registers, a, b, c)
  registers[c] = registers[a] + b
  registers
end

def mulr(registers, a, b, c)
  registers[c] = registers[a] * registers[b]
  registers
end

def muli(registers, a, b, c)
  registers[c] = registers[a] * b
  registers
end

def banr(registers, a, b, c)
  registers[c] = registers[a] & registers[b]
  registers
end

def bani(registers, a, b, c)
  registers[c] = registers[a] & b
  registers
end

def borr(registers, a, b, c)
  registers[c] = registers[a] | registers[b]
  registers
end

def bori(registers, a, b, c)
  registers[c] = registers[a] | b
  registers
end

def setr(registers, a, b, c)
  registers[c] = registers[a]
  registers
end

def seti(registers, a, b, c)
  registers[c] = a
  registers
end

def gtir(registers, a, b, c)
  registers[c] = a > registers[b] ? 1 : 0
  registers
end

def gtri(registers, a, b, c)
  registers[c] = registers[a] > b ? 1 : 0
  registers
end

def gtrr(registers, a, b, c)
  registers[c] = registers[a] > registers[b] ? 1 : 0
  registers
end

def eqir(registers, a, b, c)
  registers[c] = a == registers[b] ? 1 : 0
  registers
end

def eqri(registers, a, b, c)
  registers[c] = registers[a] == b ? 1 : 0
  registers
end

def eqrr(registers, a, b, c)
  registers[c] = registers[a] == registers[b] ? 1 : 0
  registers
end

@register_5 = 0
def run_code registers, code, part
  @register_5 = registers[5]
  while registers[@ip_register] < code.length
    instruction = code[registers[@ip_register]]
    opcode, a, b, c = instruction
    registers = send(opcode, registers, a, b, c)
    if registers[0] == 0 && part == 2
      @register_5 = registers[5]
      break
    end
    registers[@ip_register] += 1
  end
  registers
end

def sum_of_divisors_for_int number
  sum = 0
  (1..number).each do |i|
    sum += i if number % i == 0
  end
  sum
end

registers = [0, 0, 0, 0, 0, 0]

registers = run_code(registers, code, 1)

puts registers[0]


def sum_of_divisors_for_int number
  sum = 0
  (1..number).each do |i|
    sum += i if number % i == 0
  end
  sum
end

registers = [1, 0, 0, 0, 0, 0]

registers = run_code(registers, code, 2)

target = @register_5

puts sum_of_divisors_for_int(target)

# instructions:

# 0: registers[4] = registers[4] + 16
# 1: registers[1] = 1
# 2: registers[2] = 1
# 3: registers[3] = registers[1] * registers[2]
# 4: registers[3] = registers[3] == registers[5] ? 1 : 0
# 5: registers[4] = registers[3] + registers[4]
# 6: registers[4] = registers[4] + 1
# 7: registers[0] = registers[1] + registers[0]
# 8: registers[2] = registers[2] + 1
# 9: registers[3] = registers[2] > registers[5] ? 1 : 0
# 10: registers[4] = registers[4] + registers[3]
# 11: registers[4] = 2
# 12: registers[1] = registers[1] + 1
# 13: registers[3] = registers[1] > registers[5] ? 1 : 0
# 14: registers[4] = registers[3] + registers[4]
# 15: registers[4] = 1
# 16: registers[4] = registers[4] * registers[4]
# 17: registers[5] = registers[5] + 2
# 18: registers[5] = registers[5] * registers[5]
# 19: registers[5] = registers[4] * registers[5]
# 20: registers[5] = registers[5] * 11
# 21: registers[3] = registers[3] + 4
# 22: registers[3] = registers[3] * registers[4]
# 23: registers[3] = registers[3] + 21
# 24: registers[5] = registers[5] + registers[3]
# 25: registers[4] = registers[4] + registers[0]
# 26: registers[4] = 0
# 27: registers[3] = registers[4]
# 28: registers[3] = registers[3] * registers[4]
# 29: registers[3] = registers[4] + registers[3]
# 30: registers[3] = registers[4] * registers[3]
# 31: registers[3] = registers[3] * 14
# 32: registers[3] = registers[3] * registers[4]
# 33: registers[5] = registers[5] + registers[3]
# 34: registers[0] = 0
# 35: registers[4] = 0


# registers[4] = 0
# while registers[4] <= 36
#   next_instruction_index = registers[4]
#   run_instruction(next_instruction_index)
#   registers[4] += 1
# end

#  0 - [1, 0, 0, 0, 0, 0] ->                [1, 0, 0, 0, 16, 0]
# 17 - [1, 0, 0, 0, 17, 0] ->               [1, 0, 0, 0, 17, 2]
# 18 - [1, 0, 0, 0, 18, 2] mulr 5 5 5       [1, 0, 0, 0, 18, 4]
# 19 - [1, 0, 0, 0, 19, 4] mulr 4 5 5       [1, 0, 0, 0, 19, 76]
# 20 - [1, 0, 0, 0, 20, 76] muli 5 11 5     [1, 0, 0, 0, 20, 836]
# 21 - [1, 0, 0, 0, 21, 836] addi 3 4 3     [1, 0, 0, 4, 21, 836]
# 22 - [1, 0, 0, 4, 22, 836] mulr 3 4 3     [1, 0, 0, 88, 22, 836]
# 23 - [1, 0, 0, 88, 23, 836] addi 3 21 3 3 [1, 0, 0, 109, 23, 836]
# 24 - [1, 0, 0, 109, 24, 836] addr 5 3 5            [1, 0, 0, 109, 24, 945]
# 25 - [1, 0, 0, 109, 25, 945] addr 4 0 4            [1, 0, 0, 109, 26, 945]
# 27 - [1, 0, 0, 109, 27, 945] setr 4 1 3            [1, 0, 0, 27, 27, 945]
# 28 - [1, 0, 0, 27, 28, 945] mulr 3 4 3             [1, 0, 0, 756, 28, 945]
# 29 - [1, 0, 0, 756, 29, 945] addr 4 3 3            [1, 0, 0, 785, 29, 945]
# 30 - [1, 0, 0, 785, 30, 945] mulr 4 3 3            [1, 0, 0, 23550, 30, 945]
# 31 - [1, 0, 0, 23550, 31, 945] muli 3 14 3         [1, 0, 0, 329700, 31, 945]
# 32 - [1, 0, 0, 329700, 32, 945] mulr 3 4 3         [1, 0, 0, 10550400, 32, 945]
# 33 - [1, 0, 0, 10550400, 33, 945] addr 5 3 5       [1, 0, 0, 10550400, 33, 10551345]
# 34 - [1, 0, 0, 10550400, 34, 10551345] seti 0 2 0  [0, 0, 0, 10550400, 34, 10551345]
# 35 - [0, 0, 0, 10550400, 35, 10551345] seti 0 0 4  [0, 0, 0, 10550400, 0, 10551345]
# 1 -  [0, 0, 0, 10550400, 1, 10551345] seti 1 7 1   [0, 1, 0, 10550400, 1, 10551345]

# Part 2 [0, 0, 0, 10550400, 1, 10551345] => 10551345 answer
# Part 1 [0, 0, 0,      109, 1,      945] => 1920 answer
