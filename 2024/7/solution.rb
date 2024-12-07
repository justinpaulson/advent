require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)


answers = []
lines.each do |line|
  answer, values = line.split(": ")
  values = values.split(" ").map(&:to_i)
  answer = answer.to_i

  # puts "evaluating values #{values}"
  operators = ["+", "*"]
  operators.repeated_permutation(values.length - 1).each do |ops|
    # puts "checking ops #{ops}"
    eval_string = "#{values[0]}"
    result = values[0]
    values[1..-1].each_with_index do |value, index|
      eval_string += " #{ops[index]} #{value}"
      result = eval("#{result} #{ops[index]} #{value}")
    end
    # puts "evaluating #{eval_string} = #{result}"
    if result == answer
      # puts line
      answers << answer
      break
    end
  end
end

puts answers.sum

puts "bit slow for part 2 (2-3 minutes)"
answers = []
lines.each do |line|
  answer, values = line.split(": ")
  values = values.split(" ").map(&:to_i)
  answer = answer.to_i

  # puts "evaluating values #{values}"
  operators = ["+", "*", "||"]
  operators.repeated_permutation(values.length - 1).each do |ops|
    # puts "checking ops #{ops}"
    eval_string = "#{values[0]}"
    result = values[0]
    values[1..-1].each_with_index do |value, index|
      eval_string += " #{ops[index]} #{value}"
      case ops[index]
      when "+", "*"
        result = eval("#{result} #{ops[index]} #{value}")
      when "||"
        result = "#{result}#{value}".to_i
      end
    end
    # puts "evaluating #{eval_string} = #{result}"
    if result == answer
      # puts line
      answers << answer
      break
    end
  end
end

puts answers.sum
