lines = IO.readlines("input")

red_max = 12
green_max = 13
blue_max = 14

games = {}

lines.each do |line|
  possible = true
  id = line.split("Game ")[1].split(":")[0].to_i
  games[id] = line.split(": ")[1].split("; ")
  games[id].each do |game|
    game = game.split(", ")
    game.each do |grab|
      color = grab.split(" ")[1]
      cubes = grab.split(" ")[0].to_i
      if color == "red"
        if cubes > red_max
          possible = false
        end
      elsif color == "green"
        if cubes > green_max
          possible = false
        end
      elsif color == "blue"
        if cubes > blue_max
          possible = false
        end
      end
    end
  end
  games[id] = possible
end

puts games.select{|k,v| v}.keys.sum

games = {}

lines.each do |line|
  red_max = 0
  green_max = 0
  blue_max = 0
  id = line.split("Game ")[1].split(":")[0].to_i
  games[id] = line.split(": ")[1].split("; ")
  games[id].each do |game|
    game = game.split(", ")
    game.each do |grab|
      color = grab.split(" ")[1]
      cubes = grab.split(" ")[0].to_i
      if color == "red"
        if cubes > red_max
          red_max = cubes
        end
      elsif color == "green"
        if cubes > green_max
          green_max = cubes
        end
      elsif color == "blue"
        if cubes > blue_max
          blue_max = cubes
        end
      end
    end
  end
  games[id] = red_max * blue_max * green_max
end

puts games.values.sum
