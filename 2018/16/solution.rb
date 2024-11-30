require '../../grid.rb'
ARGV[0] ||= "input"
file = IO.read(ARGV[0])
tests, code = file.split("\n\n\n\n")
code = code.split("\n").map(&:chomp).map{|l| l.split(" ").map(&:to_i)}

tests = tests.split("\n\n").map do |test|
  before, instruction, after = test.split("\n")
  before = before.delete("Before:[").delete("]").split(", ").map(&:to_i)
  after = after.delete("After:[").delete("]").split(", ").map(&:to_i)
  instruction = instruction.split(" ").map(&:to_i)
  [before, after, instruction]
end

possible_opcodes = {
  addr: [],
  addi: [],
  mulr: [],
  muli: [],
  banr: [],
  bani: [],
  borr: [],
  bori: [],
  setr: [],
  seti: [],
  gtir: [],
  gtri: [],
  gtrr: [],
  eqir: [],
  eqri: [],
  eqrr: []
}

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
  a > registers[b] ? registers[c] = 1 : registers[c] = 0
  registers
end

def gtri(registers, a, b, c)
  registers[a] > b ? registers[c] = 1 : registers[c] = 0
  registers
end

def gtrr(registers, a, b, c)
  registers[a] > registers[b] ? registers[c] = 1 : registers[c] = 0
  registers
end

def eqir(registers, a, b, c)
  a == registers[b] ? registers[c] = 1 : registers[c] = 0
  registers
end

def eqri(registers, a, b, c)
  registers[a] == b ? registers[c] = 1 : registers[c] = 0
  registers
end

def eqrr(registers, a, b, c)
  registers[a] == registers[b] ? registers[c] = 1 : registers[c] = 0
  registers
end

total_three_or_more = 0

tests.each do |test|
  before, after, instruction = test
  opcode, a, b, c = instruction
  total = 0
  possible_opcodes.keys.each do |test_code|
    result = send(test_code, before.dup, a, b, c)
    if result == after
      total += 1
      possible_opcodes[test_code] << opcode unless possible_opcodes[test_code].include?(opcode)
    else
      possible_opcodes[test_code] -= [opcode]
    end
  end
  total_three_or_more += 1 if total >= 3
end

puts total_three_or_more


while(possible_opcodes.values.map(&:length).any?{|l| l > 1})
  possible_opcodes.select{|k,v| v.length == 1}.each do |k,v|
    possible_opcodes.each do |k2,v2|
      next if k == k2
      v2.delete(v[0])
    end
  end
end

opcodes = possible_opcodes.map{|k,v| [k, v[0]]}.to_h

registers = [0, 0, 0, 0]
code.each do |instruction|
  opcode, a, b, c = instruction
  registers = send(opcodes.key(opcode), registers, a, b, c)
end

puts registers[0]
