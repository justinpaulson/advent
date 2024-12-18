require '../../grid.rb'
ARGV[0] ||= "input"
# lines = IO.readlines(ARGV[0]).map(&:chomp)

registers =
{
  A: 64854237,
  B: 0,
  C: 0
}

program = [2,4,1,1,7,5,1,5,4,0,5,5,0,3,3,0]

if ARGV[0] == "test"
  registers[:A] = 729
  program = [0,1,5,4,3,0]
end

def run_program registers, program
  a = registers[:A]
  b = registers[:B]
  c = registers[:C]
  output = []
  while a != 0
    # puts "a: #{a}, b: #{b}, c: #{c}, output: #{output}"
    b = a % 8
    b = b ^ 1
    c = a / (2**b)
    b = b ^ 5
    b = b ^ c
    output << b % 8
    a = a / (2**3)
    # key_wait
  end
  output.join(',')
end

# part 1
puts run_program(registers, program)

# Basically I kept finding the value that made the next step in the program
# starting with "0,3,3,0" because it was very fast
# then I would take that value and multiply by just less than 8 and run it again
# until I found the next value, like "5,0,3,3,0"
# I may write a program to do it, but I haven't yet!
#
#
count = (20534878121424 * 7.99999999).to_i

registers[:A] = count

answer = run_program(registers, program)

# 78334343 produces "5,4,0,5,5,0,3,3,0"
# 626674746 produces "1,5,4,0,5,5,0,3,3,0"
# 5013397978 produces "5,1,5,4,0,5,5,0,3,3,0"
# 40107183830 produces "7,5,1,5,4,0,5,5,0,3,3,0"
# 320857470647 produces "1,7,5,1,5,4,0,5,5,0,3,3,0"
# 2566859765178 produces "1,1,7,5,1,5,4,0,5,5,0,3,3,0"
# 20534878121424 produces "4,1,1,7,5,1,5,4,0,5,5,0,3,3,0"
while   answer != "2,4,1,1,7,5,1,5,4,0,5,5,0,3,3,0"
  count += 1
  registers[:A] = count
  registers[:B] = 0
  registers[:C] = 0
  answer = run_program(registers, program)
  puts "#{count} 0 0: #{answer}"
end

exit

registers[:A] = 2390


0.upto(50) do |i|
  registers[:A] = 2390 * 8**i
  registers[:B] = 0
  registers[:C] = 0
  answer = run_program(registers, program)
  puts "#{i} 0 0: #{answer}"
end


#  0, 4, 1, 5, 2, 3, 1,
#  3 start 171523813932000
#  0, 3, 0 -> 4, 3, 0 : 172073569746944
#  4, 3, 0 -> 1, 3, 0 : 172623325560832
#  1, 3, 0 -> 2, 3, 0 : 174272593002496
#  2, 3, 0 -> 0, 3, 0 : 174822348816384
#  0, 3, 0 -> 7, 3, 0 : 175372104630272
#  3 end   175921860444159

175921860000000.upto(175921860444159) do |a|
  registers[:A] = a
  registers[:B] = 0
  registers[:C] = 0
  answer = run_program(registers, program)
  if answer == program.join(',')
    puts "Answer: #{a}"
    exit
  end
  puts "#{a} 0 0: #{answer}" if a % 1000 == 0
  # key_wait
end

@a = registers[:A]
answer = run_program(registers, program)
while program.join(',').length != answer[-11..-1].length
  @a *= 8
  registers[:A] = @a
  registers[:B] = 0
  registers[:C] = 0
  answer = run_program(registers, program)
  puts "#{@a} 0 0: #{run_program(registers, program)}"
  key_wait
end
