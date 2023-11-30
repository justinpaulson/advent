require "../../grid"

lines = IO.readlines("test_input2").map(&:chomp)

def snafu_to_num snafu
  (snafu.chars.reverse.each_with_index.map do |c, i|
    case c
    when "1"
      5**i * 1
    when "2"
      5**i * 2
    when "0"
      5**i * 0
    when "-"
      5**i * (-1)
    when "="
      5**i * (-2)
    end
  end).sum
end

nums = lines.map do |line|
  (line.chars.reverse.each_with_index.map do |c, i|
    case c
    when "1"
      5**i * 1
    when "2"
      5**i * 2
    when "0"
      5**i * 0
    when "-"
      5**i * (-1)
    when "="
      5**i * (-2)
    end
  end).sum
end

p nums.to_s

p nums.sum

p (nums.sum.to_s(5).chars.map do |c|
  case c
  when "0"
    "="
  when "1"
    "-"
  when "2"
    "0"
  when "3"
    "1"
  when "4"
    "2"
  end
end).join


# def dec_to_snafu dec
#   out = ""
#   i = 0
#   while(5**i < dec)
#     i += 1
#   end

#   i -= 1

#   while dec > 0
#     digit = dec / (5**i)
#     dec = dec - ((5**i) * digit)
#     out << digit.to_s

#     i -= 1
#   end

# end


#   current = 0
#   while dec != 0
#     char = (dec+2).to_s(5)[-1]
    
#     digit = case char
#     when "0"
#       -2
#     when "1"
#       -1
#     when "2"
#       0
#     when "3"
#       1
#     when "4"
#       2
#     end
#     dec = dec - (digit * 5**current)
#   end
# end



# decs = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20, 2022, 12345, 314159265]

# p decs.to_s

# decs.each{|d| puts dec_to_snafu (d+2)}

def next_snafu t
  carry_one = true
  out = t.chars.reverse.map do |c|
    if carry_one
      case c
      when "1"
        carry_one = false
        "2"
      when "2"
        carry_one = true
        "="
      when "="
        carry_one = false
        "-"
      when "-"
        carry_one = false
        "0"
      when "0"
        carry_one = false
        "1"
      end
    else
      c
    end
  end
  out = out.join.reverse
  if carry_one
    out = "1" + out
  end
  out
end

tester = "122-12==0-0000000000"

28115957031251.upto(28115957264952) do |i|
  puts i if i% 100000000 == 0
  tester = next_snafu (tester)
end
puts tester
