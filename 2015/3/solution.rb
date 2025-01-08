ARGV[0] ||= "input"
lines = IO.read(ARGV[0])
houses1 = {"[0, 0]"=>1}
houses2 = {"[0, 0]"=>1}
santa = [0,0]
santa2 = [0,0]
robo_santa = [0,0]
lines.each_char.each_with_index do |c, i|
  case c
  when "^"
    santa[1] += 1
    i.even? ? santa2[1] += 1 : robo_santa[1] += 1
  when "v"
    santa[1] -= 1
    i.even? ? santa2[1] -= 1 : robo_santa[1] -= 1
  when ">"
    santa[0] += 1
    i.even? ? santa2[0] += 1 : robo_santa[0] += 1
  when "<"
    santa[0] -= 1
    i.even? ? santa2[0] -= 1 : robo_santa[0] -= 1
  end
  houses1[santa.to_s] ||= 1
  houses2[santa2.to_s] ||= 1
  houses2[robo_santa.to_s] ||= 1
end
puts houses1.keys.count
puts houses2.keys.count
