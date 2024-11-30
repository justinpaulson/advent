p File.read("input").scan(/[0-9]+|-[0-9]+/).sum(&:to_i)

input = File.read("input")

while next_red = input.index(":\"red\"")
  right_total = 0
  opening = nil
  (next_red-1).downto(0) do |i|
    right_total += 1 if input[i] == "}"
    right_total -= 1 if input[i] == "{"
    if right_total == -1
      opening = i
      break
    end
  end

  left_total = 0
  closing = nil
  (next_red+1).upto(input.length-1) do |i|
    left_total += 1 if input[i] == "{"
    left_total -= 1 if input[i] == "}"
    if left_total == -1
      closing = i
      break
    end
  end
  input = input[0...opening-1] + input[closing+1..-1]
end

p input.scan(/[0-9]+|-[0-9]+/).sum(&:to_i)

# first_phase = File.read("input").gsub(/(\[[^\{\}]+\])/){|arr| arr.scan(/[0-9]+|-[0-9]+/).sum(&:to_i).to_s}
# first_phase = first_phase.gsub(/\{[^\{\[]*red[^\}\]]*\}/, ".").scan(/[0-9]+|-[0-9]+/).sum(&:to_i)

# puts first_phase

# 54661 : too low

# 69112 : close
# 78257 : close

# 96260 : too high
