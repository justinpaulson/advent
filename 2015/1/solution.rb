ARGV[0] ||= "input"
line = IO.read(ARGV[0]).chomp
puts line.count("(") - line.count(")")
position = 0
line.each_char.each_with_index do |c, i|
  position += c == "(" ? 1 : -1;
  if position < 0
    puts i+1
    break
  end
end
