require '../../grid.rb'
ARGV[0] ||= "input"
line = IO.read(ARGV[0]).chomp

def deserialize line
  out_line = []
  line.chars.each_with_index do |c, i|
    if i.even?
      out_line << [(i/2)] * c.to_i
    else
      out_line << ["."] * c.to_i
    end
  end
  out_line.flatten
end

@start_index = 0
def move_one line
  return line[0..-2] if line[-1] == "."
  while line[@start_index] != "."
    @start_index += 1
  end
  line[@start_index] = line[-1]
  line[0..-2]
end

def finished_line line
  index = line.length - 1
  element = line[index]
  while element == "."
    index -= 1
    element = line[index]
  end
  !(line[0..index].include?("."))
end

line = deserialize(line)

while !finished_line(line)
  line = move_one(line)
end

ans = line.each_with_index.map do |c, i|
  c != "." ? c * i : 0
end.sum

puts ans

line = IO.read(ARGV[0]).chomp

line = deserialize(line)

def next_hole line, width, thresh
  cursor = 0
  cursor += 1 while cursor < thresh && line[cursor] != "."
  return nil if cursor == thresh

  current = line[cursor]
  start = cursor
  ending = cursor
  ending += 1 while ending < thresh && line[ending] == "."
  ending -= 1

  while ending - start + 1 < width
    start = ending + 1
    start += 1 while start < thresh && line[start] != "."
    return nil if start == thresh

    ending = start
    ending += 1 while ending < thresh && line[ending] == "."
    ending -= 1
  end

  [start, ending]
end

def move_file line, cursor
  if line[cursor] == "."
    cursor -= 1 while cursor > 0 && line[cursor] == "."
  end

  current = line[cursor]
  start = cursor
  start -= 1 while start > 0 && line[start] == current
  return [line, 0] if start == 0
  width = cursor - start
  start += 1

  hole = next_hole(line, width, start)

  unless hole.nil?
    line[hole[0]..hole[0] + width - 1] = [current] * (width)
    line[start..cursor] = ["."] * (width)
  end

  [line, start - 1]
end

line = IO.read(ARGV[0]).chomp

line = deserialize(line)

cursor = line.length - 1
while cursor > 0
  line, cursor = move_file(line, cursor)
end

ans = line.each_with_index.map do |c, i|
  c != "." ? c * i : 0
end.sum

puts ans
