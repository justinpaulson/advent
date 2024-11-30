lines = File.readlines("input")

guards = Hash.new

# lines are given in the date format YYYY-MM-DD HH:MM
# they look like this [1518-11-01 00:00] Guard #10 begins shift
# they look like this [1518-11-01 00:05] falls asleep
# they look like this [1518-11-01 00:25] wakes up
# the following code sorts the lines in chronological order

lines.sort_by! do |line|
  line.match(/\[(.*)\]/)[1]
end

# next we create a hash of guards and each minute they are asleep
# the hash looks like this {guard_id => {minute => times_asleep}}
# where a guard that was asleep from 00:00 to 00:05 would have the following entry
# {guard_id => {0 => 1, 1 => 1, 2 => 1, 3 => 1, 4 => 1}}
# if the guard slept 00:00 to 00:02 then the hash would be appended to the following
# {guard_id => {0 => 2, 1 => 2, 2 => 2, 3 => 1, 4 => 1}}

current_guard = nil
fell_asleep_at = nil
lines.each do |line|
  if line.include? "Guard"
    current_guard = line.match(/#(\d+)/)[1]
  elsif line.include? "falls asleep"
    fell_asleep_at = line.match(/:(\d+)/)[1].to_i
  elsif line.include? "wakes up"
    woke_up_at = line.match(/:(\d+)/)[1].to_i
    guards[current_guard] ||= Hash.new(0)
    (fell_asleep_at...woke_up_at).each do |minute|
      guards[current_guard][minute] += 1
    end
  end
end

# now we need to find the guard with the minute that has the highest value
# then multiply the guard id by the minute

guard_id = guards.max_by do |guard_id, minutes|
  minutes.values.sum
end

minute = guards[guard_id[0]].max_by do |minute, times_asleep|
  times_asleep
end

puts guard_id[0].to_i * minute[0]


# Part 2
# now we need to determine which guard is most frequently asleep on the same minute

guard_id = guards.max_by do |guard_id, minutes|
  minutes.values.max
end

minute = guards[guard_id[0]].max_by do |minute, times_asleep|
  times_asleep
end

puts guard_id[0].to_i * minute[0]
