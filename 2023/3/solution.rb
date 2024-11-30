ARGV[0] ||= "test"

lines = IO.readlines(ARGV[0])

def contain_symbol?(chars)
  chars.each_with_index do |char, i|
    return i if char == "*"
  end
  return false
end

part_nums = []
parts = {}

lines.each_with_index do |line, i|
  indexes = line.enum_for(:scan, /[^\.\d]/).map { Regexp.last_match.begin(0) }
  indexes.each do |index|
    parts[[i, index]] = [] if line[index] == "*"
  end
end

puts parts.to_s

lines.each_with_index do |line, j|
  in_num = false
  num = ""
  line.chars.each_with_index do |char, i|
    if char.to_i.to_s == char
      num += char
      in_num = true
    else
      if in_num
        in_num = false
        if i - num.length - 1 >= 0
          if contain_symbol?([line[i - num.length - 1]])
            puts num
            puts [line[i - num.length - 1]].to_s
            parts[[j, i - num.length - 1]] << num.to_i
            part_nums << num.to_i
            num = ""
            next
          end
        end
        if j - 1 >= 0
          start = i - num.length - 1 < 0 ? 0 : i - num.length - 1
          check_chars = lines[j - 1][start..(i == line.length - 1 ? i - 1 : i)].chars
          if ind = contain_symbol?(check_chars)
            puts num
            puts check_chars.to_s
            parts[[j-1, start + ind]] << num.to_i
            part_nums << num.to_i
            num = ""
            next
          end
        end
        if j + 1 < lines.length
          start = i - num.length - 1 < 0 ? 0 : i - num.length - 1
          check_chars = lines[j + 1][start..(i == line.length - 1 ? i - 1 : i)].chars
          if ind = contain_symbol?(check_chars)
            puts num
            puts check_chars.to_s
            parts[[j+1, start + ind]] << num.to_i
            part_nums << num.to_i
            num = ""
            next
          end
        end
        if line[i] == "*"
          puts num
          puts [line[i]].to_s
          parts[[j, i]] << num.to_i
          part_nums << num.to_i
          num = ""
        end
        num = ""
      end
    end
  end

  if in_num
    if line[lines[0].length - num.length - 1] == "*"
      puts num
      puts [line[lines[0].length - num.length - 1]].to_s
      parts[[j, lines[0].length - num.length - 1]] << num.to_i
      part_nums << num.to_i
      num = ""
      next
    end
    if j - 1 >= 0
      check_chars = lines[j - 1][(lines[0].length - num.length)..-1].chars
      if ind = contain_symbol?(check_chars)
        puts num
        puts check_chars.to_s
        parts[[j-1, ind]] << num.to_i
        part_nums << num.to_i
        num = ""
        next
      end
    end
    if j + 1 < lines.length
      check_chars = lines[j + 1][(lines[0].length - num.length)..-1].chars
      if ind = contain_symbol?(check_chars)
        puts num
        puts check_chars.to_s
        parts[[j+1, ind]] << num.to_i
        part_nums << num.to_i
        num = ""
      end
    end
  end
end

puts parts.values.flatten.sum

puts parts.select { |k, v| v.length > 1 }.values.map{|(a,b)| a * b}.sum


# TOO LOW 288203

# ## NOT 513769
# ## NOT 518161
# ## NOT 426673
