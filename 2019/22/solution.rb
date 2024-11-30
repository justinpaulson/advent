ARGV[0] ||= "input"

inputs = File.readlines(ARGV[0]).map(&:strip).map do |line|
  if line == "deal into new stack"
    ["dins",0]
  else
    [line.split(' ')[0] == 'cut' ? 'c' : 'dwi', line.split(' ').last.to_i]
  end
end

def deal_into_new_stack
  @front = (@front + 1) % 2
end

def cut(stack, index)
  index = stack.length + index if index < 0
  cut_index = @front == 0 ? index : stack.length - index
  stack[index..-1] + stack[0..index-1]
end

def deal_with_increment(stack, freq)
  out_stack = []
  if @front == 0
    0.upto(stack.length - 1) do |i|
      out_stack[i * freq % stack.length] = stack[i]
    end
  else
    (stack.length-1).downto(0) do |i|
      out_stack[i * freq % stack.length] = stack[i]
    end
  end
  out_stack
end

size = 10007
stack = {}
@front = 0
inputs.each do |(act, value)|
  case act
  when 'dwi'
    stack = deal_with_increment(stack, value)
  when 'dins'
    deal_into_new_stack
  when 'c'
    stack = cut(stack, value)
  end
end
stack.each_with_index{|s, i| puts i if s == 2019}

size = 119315717514047
stack = [*0..size-1]
@front = 0
results = []
s = 1
while s < 101741582076661
  inputs.each do |(act, value)|
    case act
    when 'dwi'
      stack = deal_with_increment(stack, value)
    when 'dins'
      stack = deal_into_new_stack(stack)
    when 'c'
      stack = cut(stack, value)
    end
  end
  puts s
  s += 1
end
stack.each_with_index{|s, i| puts i if s == 2020}

m = 119315717514047

# "deal into new stack" moves cards from position 𝑥
#  to position 𝑚−𝑥−1
# . We can write this as 𝑓(𝑥)=𝑚−𝑥−1
# .
# "cut 𝑛
# " moves cards from position 𝑥
#  to position 𝑥−𝑛  mod 𝑚
#  (note how indices "wrap around" to the other side), Thus 𝑓(𝑥)=𝑥−𝑛  mod 𝑚
# . Note this also works for the version with negative 𝑛
# .
# "deal with increment 𝑛
# " moves cards from position 𝑥
#  to position 𝑛⋅𝑥  mod 𝑚
# . Thus, 𝑓(𝑥)=𝑛⋅𝑥  mod 𝑚

# 2020 = m - x - 1
# x = m - 2021


# 6821410630991
