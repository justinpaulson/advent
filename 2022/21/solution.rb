lines = IO.readlines("input").map(&:chomp)

equations = {}
nums = {}

me = "humn"

lines.each do |line|
  name, val = line.split(": ")
  if val.to_i.to_s == val
    val = val.to_i
    nums[name] = val
  else
    first = val[0..3]
    second = val[7..-1]
    oper = val[5]
    equations[name] = "nums['#{first}'] #{oper} nums['#{second}']"
  end
end

while nums["root"].nil?
  puts "--------------------------------------------"
  equations.each do |name, equat|
    next if name == "root"
    next if equat.to_i == equat
    next if equat.match(/humn/)
    begin
      if eval(equat).to_i
        nums[name] = eval(equat).to_i
        equations[name] = eval(equat).to_i
      end
    rescue NoMethodError, TypeError
      next
    end
  end
  puts equations.to_s
end

# need "rvrh" == 5697586809113

# equations = {}
# nums = {}

# equations["rvrh"]

# lines.each do |line|
#   name, val = line.split(": ")
#   if val.to_i.to_s == val
#     val = val.to_i
#     nums[name] = val
#   else
#     first = val[0..3]
#     second = val[7..-1]
#     oper = val[5]
#     equations[name] = "nums['#{first}'] #{oper} nums['#{second}']"
#   end
# end


# puts nums["root"]

# nums = {}
# equations = {}

# lines.each do |line|
#   name, val = line.split(": ")
#   if val.to_i.to_s == val
#     val = val.to_i
#     nums[name] = val
#   else
#     first = val[0..3]
#     second = val[7..-1]
#     oper = val[5]
#     oper = "=" if name == "root"
#     equations[name] = "nums['#{first}'] #{oper} nums['#{second}']"
#   end
# end

# while nums["root"] != true
#   left, right = equations["root"].split(" = ")
#   loop do
#     if left == "humn"
#     elsif right == "humn"
#     end
#     left, right = equations[left]
#   end
#   equations.each do |name, equat|
#     begin
#       if eval(equat).to_i
#         nums[name] = eval(equat).to_i
#         equations[name] = eval(equat).to_i
#       end
#     rescue NoMethodError, TypeError
#       next
#     end
#   end
# end