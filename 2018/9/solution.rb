ARGV[0] ||= "input"

input = File.read(ARGV[0]).chomp
players = input.split(" ")[0].to_i
last_marble = input.split(" ")[6].to_i

players = Array.new(players, 0)
marbles = []

turn = 0
0.upto(last_marble).each do |marble|
  if marble % 23 == 0 && marble != 0
    players[turn] += marble
    marbles.rotate!(-7)
    players[turn] += marbles.shift
  else
    marbles.rotate!(2)
    marbles.unshift(marble)
  end
  turn = (turn + 1) % players.length
end

puts players.max

# Slooooooooow
(last_marble+1).upto(last_marble*100).each do |marble|
  if marble % 23 == 0 && marble != 0
    players[turn] += marble
    marbles.rotate!(-7)
    players[turn] += marbles.shift
  else
    marbles.rotate!(2)
    marbles.unshift(marble)
  end
  turn = (turn + 1) % players.length
  puts marble if marble % 100000 == 0 # 7090400
end

puts players.max
