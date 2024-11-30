lines = IO.readlines("input")
swaps = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9
}
puts (lines.map do |line|
  digits = line.scan(/(?=(\d))/).flatten
  first = digits[0].to_i != 0 ? digits[0].to_i : swaps[digits[0]]
  last = digits[-1].to_i != 0 ? digits[-1].to_i : swaps[digits[-1]]
  (first.to_s + last.to_s).to_i
end).sum

puts (lines.map do |line|
  digits = line.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/).flatten
  first = digits[0].to_i != 0 ? digits[0].to_i : swaps[digits[0]]
  last = digits[-1].to_i != 0 ? digits[-1].to_i : swaps[digits[-1]]
  (first.to_s + last.to_s).to_i
end).sum
