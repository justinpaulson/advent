ARGV[0] ||= "input"
lines = File.readlines(ARGV[0]).map(&:chomp)

def total_list guests, list
  list.each_with_index.map do |guest, i|
    index = (i + 1) % list.length
    guests[guest][list[index]] + guests[list[index]][guest]
  end.sum
end

guests = {}

lines.each do |line|
  line = line.gsub(".", "").gsub("gain ", "").gsub("lose ", "-").gsub("happiness units by sitting next to ", "")
  name, _, change, target = line.split(" ")
  change = change.to_i
  guests[name] ||= {}
  guests[name][target] = change
end

t = 0
t_list = []
guests.keys.permutation.each do |list|
  guest_total = total_list guests, list
  (t = guest_total; t_list = list) if guest_total > t
end

puts t

all_guests = guests.keys

guests["me"] = {}

all_guests.each{|g| guests["me"][g]=0; guests[g]["me"]=0}

t1 = 0

0.upto(t_list.length-2) do |i|
  guest_total = total_list guests, ["me"] + t_list.rotate(i)
  t1 = guest_total if t1 < guest_total
end

puts t1
