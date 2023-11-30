lines = File.readlines("input")

def total_flight time, deer
  speed, flight, rest, _ = deer[1]
  puts deer
  distance = speed * flight
  total_time = rest + flight
  t = (time / total_time) * distance
  leftover = time % total_time
  t + ([leftover, flight].min * speed)
end

def leaders_for_time deer, time
  times = {}
  max = 0
  deer.each do |d|
    curr_time = total_flight time, d
    times[d[0]] = curr_time
    max = curr_time if curr_time > max
  end
  winners = times.select{|k,v| v == max}.keys
end

deer = {}

lines.each do |line|
  name, speed, flight, rest = line.chomp.gsub(/can fly |km\/s for |seconds, but then must rest for |seconds./,"").split
  speed, flight, rest = [speed, flight, rest].map(&:to_i)
  deer[name] = [speed, flight, rest, 0]
end

time = 2503

t = 0
deer.each do |d|
  f = total_flight time, d
  t = f if t < f
end

1.upto(2503) do |time|
  leaders_for_time(deer, time).each do |win|
    deer[win][3] += 1
  end
end

furthest = deer.sort_by{|k,v| v[3]}[0][1]

puts deer.to_s
puts furthest