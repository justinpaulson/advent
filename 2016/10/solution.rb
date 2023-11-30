lines = IO.readlines("input")

def coded text
  thing,num = text.split(" ")
  thing += "s"
  "#{thing}[#{num}]"
end

bots = Array.new(210) { [] }
rules = Array.new(210) { [] }
outputs = Array.new(21) { [] }

lines.each do |line|
  if line.match?(/goes to bot/)
    value, bot = line.split(" goes to bot ")
    value = value.split(" ")[-1].to_i
    bot = bot.to_i
    bots[bot] << value
  else
    bot, rule = line.split(" gives low to ")
    bot = bot.split(" ")[-1].to_i
    first, second = rule.split(" and high to ")
    rules[bot] = [coded(first), coded(second)]
  end
end

while true
  bots.each_with_index do |bot, i|
    if bot.sort == [17,61]
      puts i
    end
    if bot.count == 2
      eval("#{rules[i][0]}<<#{bot.min}")
      eval("#{rules[i][1]}<<#{bot.max}")
      bots[i] = []
    end
  end
  if outputs[0].first && outputs[1].first && outputs[2].first
    puts outputs[0].first * outputs[1].first * outputs[2].first
    exit
  end
end