require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

ops = lines.map do |line|
  case line
  when /swap position (\d+) with position (\d+)/
    [:swap_pos, $1.to_i, $2.to_i]
  when /swap letter (\w) with letter (\w)/
    [:swap_letter, $1, $2]
  when /rotate (left|right) (\d+) steps?/
    [:rotate, $1, $2.to_i]
  when /rotate based on position of letter (\w)/
    [:rotate_pos, $1]
  when /reverse positions (\d+) through (\d+)/
    [:reverse, $1.to_i, $2.to_i]
  when /move position (\d+) to position (\d+)/
    [:move, $1.to_i, $2.to_i]
  else
    raise "Unknown op: #{line}"
  end
end

def swap_pos(password, x, y)
  password[x], password[y] = password[y], password[x]
  password
end

def swap_letter(password, x, y)
  swap_pos(password, password.index(x), password.index(y))
end

def rotate(password, dir, steps)
  steps = dir == "left" ? steps : -steps
  password.split("").rotate(steps).join
end

def rotate_pos(password, x)
  steps = password.index(x) + 1
  steps += 1 if steps >= 5
  password.split("").rotate(-steps).join
end

def delete_at password, index
  if index == 0
    return password[1..-1]
  elsif index == password.length - 1
    return password[0..-2]
  end
  password[0..index-1] + password[index+1..-1]
end

def move(password, x, y)
  char = password[x]
  password = delete_at(password, x)
  if y == 0
    password = char + password
  elsif y == password.length
    password = password + char
  else
    password = password[0..y-1] + char + password[y..-1]
  end
  password
end

password = "abcdefgh"

ops.each do |op|
  case op[0]
  when :swap_pos
    password = swap_pos(password, op[1], op[2])
  when :swap_letter
    password = swap_letter(password, op[1], op[2])
  when :rotate
    password = rotate(password, op[1], op[2])
  when :rotate_pos
    password = rotate_pos(password, op[1])
  when :reverse
    password[op[1]..op[2]] = password[op[1]..op[2]].reverse
  when :move
    password = move(password, op[1], op[2])
  else
    raise "Unknown op: #{op}"
  end
  raise "Invalid password: #{password}" unless password.length == 8
end

puts password

goal = "fbgdceah"

password = "abcdefgh"
password.split("").permutation(8).each do |comb|
  password = comb.join
  ops.each do |op|
    case op[0]
    when :swap_pos
      password = swap_pos(password, op[1], op[2])
    when :swap_letter
      password = swap_letter(password, op[1], op[2])
    when :rotate
      password = rotate(password, op[1], op[2])
    when :rotate_pos
      password = rotate_pos(password, op[1])
    when :reverse
      password[op[1]..op[2]] = password[op[1]..op[2]].reverse
    when :move
      password = move(password, op[1], op[2])
    else
      raise "Unknown op: #{op}"
    end
    raise "Invalid password: #{password}" unless password.length == 8
  end
  if password == goal
    puts comb.join
    exit
  end
end
