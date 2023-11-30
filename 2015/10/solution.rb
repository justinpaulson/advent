input1 = "1113222113"


# too big: "5712667"
# too big: "5712665"
# too big: "3659708"

50.times do |i|
  new_input = ""
  l = nil
  t = 0
  input1.chars.each do |c|
    (l = c; t=1; next) unless l
    if l == c
      t += 1
    else
      new_input += t.to_s
      new_input += l
      t = 1
    end
    l = c
  end
  new_input += t.to_s
  new_input += l
  input1 = new_input
  puts i
end

puts input1.length
