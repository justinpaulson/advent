ARGV[0] ||= "input"

p File.read(ARGV[0]).scan(/[0-9]+|-[0-9]+/).sum(&:to_i)

input = File.read(ARGV[0])

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
