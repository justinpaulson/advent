require '../../grid.rb'
require 'digest'

ARGV[0] ||= "input"
input = File.read(ARGV[0]).strip

position = [0,0]
queue = [[position, input]]
current_hash = ""
solutions = []
while queue.length > 0
  position, current_hash = queue.shift

  if position == [3,3]
    solutions << current_hash[input.length..-1]
    next
  end

  hash = Digest::MD5.hexdigest(current_hash)

  if position[0] > 0 && hash[0] =~ /[bcdef]/
    queue << [[position[0] - 1, position[1]], current_hash + "U"]
  end
  if position[0] < 3 && hash[1] =~ /[bcdef]/
    queue << [[position[0] + 1, position[1]], current_hash + "D"]
  end
  if position[1] > 0 && hash[2] =~ /[bcdef]/
    queue << [[position[0], position[1] - 1], current_hash + "L"]
  end
  if position[1] < 3 && hash[3] =~ /[bcdef]/
    queue << [[position[0], position[1] + 1], current_hash + "R"]
  end
end

puts solutions.sort_by(&:length).first
puts solutions.sort_by(&:length).last.length
