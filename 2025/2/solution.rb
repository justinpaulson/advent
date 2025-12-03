require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.read(ARGV[0]).chomp

ranges = lines.split(",")

invalid_ids = []
part2 = 0
ranges.each do |r|
  r1, r2 = r.split("-")

  r1.to_i.upto(r2.to_i).each do |i|
    if i.to_s.match(/^([0-9]+)\1+$/)
      part2 += i
    end
  end

  next if r1.length.odd? && r2.length.odd? && r1.length == r2.length
  first_half_r1 = r1[0..((r1.length)/2)-1]
  second_half_r1 = r1[((r1.length)/2)..-1]
  first_half_r2 = r2[0..((r2.length + 1)/2)-1]
  second_half_r2 = r2[((r2.length + 1)/2)..-1]

  min = first_half_r1.length == second_half_r1.length ? (first_half_r1.to_i >= second_half_r1.to_i ? first_half_r1.to_i : (first_half_r1.to_i + 1)) : (10**first_half_r1.length)
  max = first_half_r1.length == first_half_r2.length ? (first_half_r2.to_i <= second_half_r2.to_i ? first_half_r2.to_i : first_half_r2.to_i - 1) : first_half_r2.length == second_half_r2.length ? first_half_r2.to_i : (10**first_half_r1.length)-1

  current_invalids = []
  min.upto(max).each do |i|
    current_invalids << (i.to_s + i.to_s).to_i
  end

  invalid_ids += current_invalids
end

puts invalid_ids.sum
puts part2
