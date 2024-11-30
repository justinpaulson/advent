ARGV[0] ||= "input"

lines = IO.readlines(ARGV[0])
puts lines.count

def get_type line
  cards = line.split("").group_by{|x| x}

  type = ""
  pairs = 0
  threes = 0
  fours = 0
  fives = 0
  cards.each do |card, amount|
    if amount.length == 2
      pairs += 1
    elsif amount.length == 3
      threes += 1
    elsif amount.length == 4
      fours += 1
    elsif amount.length == 5
      fives += 1
    end
  end

  if fives == 1
    type = "five"
  elsif fours == 1
    type = "four"
  elsif threes == 1 && pairs == 1
    type = "full"
  elsif threes == 1
    type = "three"
  elsif pairs == 2
    type = "two"
  elsif pairs == 1
    type = "one"
  else
    type = "high"
  end

  return type
end

def replace_joker line
  types = ["five", "four", "full", "three", "two", "one", "high"]
  card_order = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]

  jokers = line.count("J")

  return line if jokers == 0

  best_hand = 999
  out_line = line

  ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2"].repeated_permutation(jokers).each do |replacements|
    new_line = line

    replacements.each do |card|
      where_j = new_line.index("J")
      if where_j == 0
        new_line = card + new_line[1..-1]
      elsif where_j == 4
        new_line = new_line[0..3] + card
      else
        new_line = new_line[0..where_j-1] + card + new_line[where_j+1..-1]
      end
    end

    hand = get_type new_line
    if types.index(hand) < best_hand
      best_hand = types.index(hand)
      out_line = new_line
    end
  end
  out_line
end

hands = []

lines.each do |line|
  hand, value = line.split(" ")
  hands << {original: hand, value: value, best: replace_joker(hand)}
end

puts hands.count

card_order = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]

types = ["five", "four", "full", "three", "two", "one", "high"]

joker_hands = []

card_map = {}

puts hands.count

hands.sort! do |a, b|
  a_type = get_type a[:best]
  b_type = get_type b[:best]

  value = 0
  if types.index(a_type) != types.index(b_type)
    value = types.index(a_type) <=> types.index(b_type)
  else
    real_a = a[:original]
    real_b = b[:original]

    if real_a[0] != real_b[0]
      value = card_order.index(real_a[0]) <=> card_order.index(real_b[0])
    elsif real_a[0] == real_b[0] && real_a[1] != real_b[1]
      value = card_order.index(real_a[1]) <=> card_order.index(real_b[1])
    elsif real_a[0] == real_b[0] && real_a[1] == real_b[1] && real_a[2] != real_b[2]
      value = card_order.index(real_a[2]) <=> card_order.index(real_b[2])
    elsif real_a[0] == real_b[0] && real_a[1] == real_b[1] && real_a[2] == real_b[2] && real_a[3] != real_b[3]
      value = card_order.index(real_a[3]) <=> card_order.index(real_b[3])
    elsif real_a[0] == real_b[0] && real_a[1] == real_b[1] && real_a[2] == real_b[2] && real_a[3] == real_b[3] && real_a[4] != real_b[4]
      value = card_order.index(real_a[4]) <=> card_order.index(real_b[4])
    end
  end

  value
end

hands = hands.reverse

puts hands.count

puts hands.to_s

total = 0
hands.each_with_index do |hand_values, i|
  total += hand_values[:value].to_i * (i + 1)
end

puts total
