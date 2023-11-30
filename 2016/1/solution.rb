moves = IO.read("input").split(", ")

points = {}

x = 0
y = 0
dir = "^"

moves.each do |move|
  turn = move[0]
  dist = move[1..-1].to_i
  new_dir = dir
  case dir
  when "^"
    new_dir = turn == "R" ? ">" : "<"
  when "<"
    new_dir = turn == "R" ? "^" : "v"
  when ">"
    new_dir = turn == "R" ? "v" : "^"
  when "v"
    new_dir = turn == "R" ? "<" : ">"
  end
  dir = new_dir

  while dist > 0
    case dir
    when "^"
      y -= 1
    when "<"
      x -= 1
    when ">"
      x += 1
    when "v"
      y += 1
    end
    points[[x,y]] ||= 0
    points[[x,y]] += 1
    if points[[x,y]] > 1
      puts x.abs+y.abs
      exit
    end
    dist -= 1
  end

end

puts x.abs + y.abs