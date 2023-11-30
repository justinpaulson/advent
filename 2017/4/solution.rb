lines = File.readlines("input")

def valid? line
  words = {}
  line.split.each{|w| words[w] ||= 0; words[w] += 1}
  words.values.select{|v| v > 1}.length == 0
end

def valid_two? line
  words = {}
  line.split.each{|w| words[w.chars.sort.join] ||= 0; words[w.chars.sort.join] += 1}
  words.values.select{|v| v > 1}.length == 0
end

p lines.select{|line| valid? line}.count
p lines.select{|line| valid_two? line}.count



# 478 too high
# 489 too high