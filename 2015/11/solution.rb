ARGV[0] ||= "input"
password = File.read(ARGV[0]).strip

def has_straight password
  ords = password.chars.map(&:ord)
  ords[0..-3].each_with_index do |a, i|
    if a+1==ords[i+1]  && ords[i+1]+1==ords[i+2]
      return true
    end
  end
  false
end

def has_bad_letters password
  password.match?(/iol/)
end

def has_pairs password
  password.match?(/([a-z]{1})\1.*([a-z]{1})\2/)
end

def increment password
  carryover = true
  password.chars.reverse.map do |char|
    if carryover
      if char == 'z'
        char = 'a'
        carryover = true
      else
        carryover = false
        char = (char.ord + 1).chr
      end
    end
    char
  end.reverse.join
end

def valid_password password
  !has_bad_letters(password) && has_pairs(password) && has_straight(password)
end


while !valid_password(password)
  password = increment password
end

puts password

password = increment password

while !valid_password(password)
  password = increment password
end

puts password
