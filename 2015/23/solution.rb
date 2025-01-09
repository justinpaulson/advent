require '../../grid.rb'
ARGV[0] ||= "input"
@lines = IO.readlines(ARGV[0]).map(&:chomp).map do |line|
  cmd = line.split(" ")[0]
  args = line.split(" ")[1..-1].join.split(",")
  case cmd
  when "hlf","tpl","inc"
    args[0] = args[0].to_sym
  when "jie","jio"
    args[0] = args[0].to_sym
    args[1] = args[1].to_i
  when "jmp"
    args[0] = args[0].to_i
  end
  [cmd, args]
end

def run_program registers
  i = 0
  while true
    line = @lines[i]
    break if line.nil?
    cmd = line[0]
    args = line[1]
    case cmd
    when "hlf"
      registers[args[0]] /= 2
    when "tpl"
      registers[args[0]] *= 3
    when "inc"
      registers[args[0]] += 1
    when "jmp"
      i += args[0] - 1
    when "jie"
      i += args[1] - 1 if registers[args[0]].even?
    when "jio"
      i += args[1] - 1 if registers[args[0]] == 1
    end
    i += 1
  end
end

registers = { a: 0, b: 0 }
run_program registers
puts registers[:b]

registers = { a: 1, b: 0 }
run_program registers
puts registers[:b]
