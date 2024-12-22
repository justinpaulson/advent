require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp).map(&:to_i)

def mix number, value
  number ^ value
end

def prune number
  number % 16777216
end

changes = {}
secrets = {}
possibles = {}
sum = lines.map do |line|
  number = line
  changes[line] = [nil]
  secrets[line] = [line]
  possibles[line] = {}
  0.upto(1999) do
    number = mix(number * 64, number)
    number = prune number
    number = mix(number / 32, number)
    number = prune number
    number = mix number, number * 2048
    number = prune number
    changes[line] << number % 10 - secrets[line].last % 10
    secrets[line] << number
  end

  secrets[line].each_with_index do |secret, index|
    if index >= 4
      possibles[line][changes[line][index-3..index]] ||= secret % 10
    end
  end
  number
end.sum

puts sum

possible_counts = {}
possibles.each do |line, possible|
  line_possibles = {}
  possible.each do |poss, bananas|
    line_possibles[poss] ||= bananas
  end
  line_possibles.each do |poss, bananas|
    possible_counts[poss] ||= 0
    possible_counts[poss] += bananas
  end
end

puts possible_counts.max_by{|k,v| v}.last
