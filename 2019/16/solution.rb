def outputs_for_inputs_part1(inputs)
  base_pattern = [0, 1, 0, -1]
  outputs = []
  1.upto(100) do |step|
    outputs = []
    inputs.count.downto(1) do |i|
      outputs << (inputs.each_with_index.inject(0) do |tot, (input, ind)|
        tot if ind < i/2
        tot + input * base_pattern[(ind+1) % (i * 4)/ i]
      end).abs() % 10
    end
    inputs = outputs.reverse
  end
  outputs.reverse
end

def outputs_for_inputs_part2(inputs)
  base_pattern = [0, 1, 0, -1]
  outputs = []
  1.upto(100) do |step|
    outputs = []
    inputs.count.downto(1) do |i|
      if i == inputs.count
        outputs << inputs[i-1]
      elsif i > inputs.count / 2
        outputs << (outputs.last + inputs[i-1]) % 10
      else
        outputs << 0
      end
    end
    inputs = outputs.reverse
  end
  outputs.reverse
end

test_1 = "80871224585914546619083218645595".split('').map(&:to_i)
test_2 = "19617804207202209144916044189917".split('').map(&:to_i)
test_3 = "69317163492948606335995924319873".split('').map(&:to_i)
inputs = File.read("input").split('').map(&:to_i)
outputs_1 = outputs_for_inputs_part1(test_1)
outputs_2 = outputs_for_inputs_part1(test_2)
outputs_3 = outputs_for_inputs_part1(test_3)
outputs = outputs_for_inputs_part1(inputs)
raise unless outputs_1[0..7].join('') == "24176176"
raise unless outputs_2[0..7].join('') == "73745418"
raise unless outputs_3[0..7].join('') == "52432133"
raise unless outputs[0..7].join('') == "74608727"
puts "#{outputs[0..7].join('')}"

inputs = File.read("input").split('').map(&:to_i)
answer_location = inputs[0..6].join('').to_i
inputs = inputs * 10000
outputs = outputs_for_inputs_part2(inputs)
puts "#{outputs[answer_location..(answer_location+7)].join('')}"
