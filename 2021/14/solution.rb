subs = {}
IO.readlines("input").each{|l| subs[l.split(" -> ")[0]]= [l.split(" -> ")[0][0] + l.split(" -> ")[1].chomp[0], l.split(" -> ")[1].chomp[0] + l.split(" -> ")[0][1]]}

template = "ONHOOSCKBSVHBNKFKSBK"
# template = "NNCB"   # for test

pairs = {}
template.chars.each_cons(2).map{|a,b| pairs[a+b]||=0; pairs[a+b] += 1}
times = 40

while times > 0
  times -= 1

  new_pairs = {}
  subs.each do |from, s|
    if pairs[from]
      new_pairs[s[0]] ||= 0
      new_pairs[s[1]] ||= 0
      new_pairs[s[0]] += pairs[from]
      new_pairs[s[1]] += pairs[from]
    end
  end
  pairs = new_pairs
end

totes = {}

pairs.each do |pair, val|
  totes[pair[0]] ||= 0
  totes[pair[0]] += val
end

totes[template[-1]] += 1

puts totes.values.max - totes.values.min