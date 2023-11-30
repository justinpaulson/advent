lines = IO.readlines("input")

def move_tail head, tail
  zero = 0
  one = 0

  if (tail[0] - head[0]).abs > 1 || (tail[1]-head[1]).abs > 1

    if tail[0] > head[0]
      zero = tail[0] - 1
    elsif tail[0] < head[0]
      zero = tail[0] + 1
    else
      zero = tail[0]
    end
    if tail[1] > head[1]
      one = tail[1] - 1
    elsif tail[1] < head[1]
      one = tail[1] + 1
    else
      one = tail[1]
    end
  else
    zero = tail[0]
    one = tail[1]

  end
  [zero, one]
end

tail = [0,0]
head = [0,0]
tails = {}
tails[tail] = 1
lines.each do |line|

  dir, num = line.split(" ")
  num = num.to_i
  case dir
  when "U"
    num.times do 
      head[0] = head[0] - 1
      tail = move_tail(head, tail)
      tails[tail] ||= 1
    end
  when "D"
    num.times do 
      head[0] = head[0] + 1
      tail = move_tail(head, tail)
      tails[tail] ||= 1
    end
  when "L"
    num.times do 
      head[1] = head[1] - 1
      tail = move_tail(head, tail)
      tails[tail] ||= 1
    end
  else
    num.times do 
      head[1] = head[1] + 1
      tail = move_tail(head, tail)
      tails[tail] ||= 1
    end
  end
end

puts tails.keys.count


tails = {}
tails[[0,0]] = 1

body = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
lines.each do |line|

  dir, num = line.split(" ")
  num = num.to_i
  case dir
  when "U"
    num.times do 
      body[0][0] = body[0][0] - 1
      1.upto(9) do |i|
        body[i] = move_tail(body[i-1], body[i])
      end
      tails[body[9]] ||= 1
    end
  when "D"
    num.times do 
      body[0][0] = body[0][0] + 1
      1.upto(9) do |i|
        body[i] = move_tail(body[i-1], body[i])
      end
      tails[body[9]] ||= 1
    end
  when "L"
    num.times do 
      body[0][1] = body[0][1] - 1
      1.upto(9) do |i|
        body[i] = move_tail(body[i-1], body[i])
      end
      tails[body[9]] ||= 1
    end
  else
    num.times do 
      body[0][1] = body[0][1] + 1
      1.upto(9) do |i|
        body[i] = move_tail(body[i-1], body[i])
      end
      tails[body[9]] ||= 1
    end
  end
end

puts tails.keys.count


