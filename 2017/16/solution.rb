require '../../grid.rb'
ARGV[0] ||= "input"
moves = IO.read(ARGV[0]).chomp.split(",")
moves = moves.map do |move|
  args = case move[0]
  when "s"
    [move[1..-1].to_i]
  when "x"
    move[1..-1].split("/").map(&:to_i)
  when "p"
    move[1..-1].split("/")
  end
  [move[0], args].flatten
end

def move_positions positions, moves
  moves.each do |move|
    case move[0]
    when "s"
      positions.rotate!(-move[1])
    when "x"
      a_index = move[1]
      b_index = move[2]
      positions[a_index], positions[b_index] = positions[b_index], positions[a_index]
    when "p"
      a_index = positions.index(move[1])
      b_index = positions.index(move[2])
      positions[a_index], positions[b_index] = positions[b_index], positions[a_index]
    end
  end
end

positions = ("a".."p").to_a

move_positions positions, moves

puts positions.join

seen = {}
cycle = [positions.join]
seen[positions.join] = 1
cycles = 0
999999999.times do |i|
  move_positions positions, moves
  seen[positions.join] ||= 0
  seen[positions.join] += 1
  if seen[positions.join] == 2
    cycles = i + 1
    break
  end
  cycle << positions.join
end
cycle.rotate!(-1)

puts cycle[1000000000 % cycles]

# wrong
# kbgndmpholafecij
# dnoigpflajkbmhce
# dciohfjgabnpmekl
