ARGV[0] ||= "input"

lines = IO.readlines(ARGV[0])

# puts (lines.map do |line|
#   winners = line.split(": ")[1].split(" |")[0].split(" ").map(&:to_i)
#   mine = line.split(": ")[1].split("| ")[1].split(" ").map(&:to_i)

#   puts winners.to_s
#   puts mine.to_s

#   match = 0
#   mine.each do |num|
#     if winners.include?(num)
#       puts num
#       match += 1
#       next
#     end
#   end

#   puts 2**(match-1)
#   match > 0 ? 2**(match-1) : 0
# end).sum

cards = {}

lines.each_with_index do |line, i|
  winners = line.split(": ")[1].split(" |")[0].split(" ").map(&:to_i)
  mine = line.split(": ")[1].split("| ")[1].split(" ").map(&:to_i)

  cards[i] = {winners: winners, mine: mine, count: 1}
end

cards.each do |i, card|
  winners = card[:winners]
  mine = card[:mine]
  count = card[:count]
  match = 0
  mine.each do |num|
    if winners.include?(num)
      match += 1
      next
    end
  end

  if match > 0
    1.upto(match).each do |j|
      cards[i+j][:count] += count
    end
  end
end

puts cards.values.map{|c| c[:count]}.sum
