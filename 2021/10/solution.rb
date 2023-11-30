lines = IO.readlines("input").map(&:chomp)

def corrupted? line
  stack = []
  line.chars.each do |c|
    case c
    when "{","[","<","("
      stack << c
    when "}"
      if stack.last != "{"
        return [stack, "}"]
      else
        stack.pop
      end
    when ")"
      if stack.last != "("
        return [stack, ")"]
      else
        stack.pop
      end
    when ">"
      if stack.last != "<"
        return [stack, ">"]
      else
        stack.pop
      end
    when "]"
      if stack.last != "["
        return [stack, "]"]
      else
        stack.pop
      end
    end
  end
  return [stack, ""]
end

def syn_score line
  case corrupted?(line)[1]
  when ")"
    3
  when "]"
    57
  when "}"
    1197
  when ">"
    25137
  end
end

def comp_score line
  stack = corrupted?(line)[0]
  score = 0
  while stack.length > 0
    char = stack.pop
    case char
    when "("
      score = score * 5 + 1
    when "["
      score = score * 5 + 2
    when "{"
      score = score * 5 + 3
    when "<"
      score = score * 5 + 4
    end
  end
  score
end

corrupted = []
incomp = []
lines.each do |line|
  if corrupted?(line)[1] != ""
    corrupted << line 
  else
    incomp << line
  end
end

p corrupted.sum{|line| syn_score line}

p incomp.map{|line| comp_score line}.sort[incomp.length/2]