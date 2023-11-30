require "digest"

input = File.read("input").chomp

digits = []
x = 0
password = "________"
while password.match?(/_/)
  test_string = "#{input}#{x.to_s}"
  hash = Digest::MD5.hexdigest(test_string)
  if hash[0..4] == "00000"
    digits << hash[5] if digits.length < 8
    if hash[5] == hash[5].to_i.to_s && hash[5].to_i >= 0 && hash[5].to_i <= 7
      password[hash[5].to_i] = hash[6] if password[hash[5].to_i] == "_"
    end
    puts password
  end
  x += 1
end

# wrong 4050cbbd

puts digits.join

puts password