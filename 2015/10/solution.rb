ARGV[0] ||= "input"
input1 = File.read(ARGV[0]).strip

# Sloooooow takes around 30 minutes or more to run
# need to look into a solution that updates the pieces in groups
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
  if i == 39
    puts input1.length
  end
end

puts input1.length
