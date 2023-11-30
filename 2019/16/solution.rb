def outputs_for_inputs(inputs)
  base_pattern = [0, 1, 0, -1]
  outputs = []
  1.upto(100) do |step|
    outputs = []
    inputs.count.downto(1) do |i|
      outputs << (inputs.each_with_index.inject(0) do |tot, (input, ind)|
        tot if ind < i-1
        tot + 
        case (ind+1) % (i * 4)/ i
        when 0
          0
        when 1
          input
        when 2
          0
        when 3
          -input
        end
      end).abs() % 10
      puts i
    end
    inputs = outputs
    puts outputs[0..8].join('')
  end
  outputs
end

inputs = File.read("input").split('').map(&:to_i)

outputs = outputs_for_inputs(inputs)

puts "Answer part 1: #{outputs[0..7].join('')}"

puts outputs.join

# puts "Hold onto your butts for part two!!...."
# answer_location = inputs[0..6].join('').to_i
# inputs = inputs * 10000
# outputs = outputs_for_inputs(inputs)
# puts "Answer: #{outputs[answer_location..(answer_location+7)].join('')}"
