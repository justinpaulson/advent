def line_explode line
  # puts "explode: #{line}"
  cursor = 0
  left_count = 0
  right_count = 0
  output = line
  while cursor < line.length - 1
    left_count += 1 if line[cursor] == "["
    right_count += 1 if line[cursor] == "]"
    if left_count == 5 + right_count
      cursor += 1

      nums = Array.new(line.length) { nil }
      line.scan(/[0-9]+/){|n| nums[Regexp.last_match.offset(0).first] = n }

      while !nums[cursor] do 
        cursor += 1 
      end

      left_cursor = cursor - 1
      while !nums[left_cursor] && left_cursor > 0
        left_cursor -= 1
      end

      # puts "We are working at cursor #{cursor}, value: #{nums[cursor]}"
      left_num = nums[cursor].to_i
      found_num = nums[left_cursor].to_i

      left_string = ""
      if left_cursor == 0
        left_string = line[0..cursor-2]
      else
        # puts "We found numbers at #{left_cursor}  - #{nums[left_cursor]}"
        left_string = line[0..left_cursor-1] + (left_num + found_num).to_s + line[left_cursor+nums[left_cursor].length..cursor-2]
      end

      cursor = cursor + nums[cursor].length + 1

      right_cursor = cursor + 1
      while !nums[right_cursor] && right_cursor < line.length - 1
        right_cursor += 1
      end

      right_num = nums[cursor].to_i
      found_num = nums[right_cursor].to_i

      right_string = ""
      if right_cursor == line.length - 1
        right_string = line[cursor+right_num.to_s.length+1..-1]
      else
        right_string = line[cursor+nums[cursor].length+1..right_cursor-1] + (right_num + found_num).to_s + line[right_cursor+(found_num).to_s.length..-1]
      end

      output = left_string + "0" + right_string
      break
    end
    cursor += 1
  end
  output
end

def line_split line
  # puts "split: #{line}"
  matches = line.match(/[0-9]{2}/)
  return line unless matches
  cursor = line.index(matches[0])
  val = line[cursor..cursor+1].to_i
  left = val / 2
  right = val - left
  line[0..cursor-1] + "[" + left.to_s + "," + right.to_s + "]" +line[cursor+2..-1]
end

def line_reduce line
  new_line = nil
  while new_line != line
    line = new_line || line
    new_sub_line = nil
    while new_sub_line != line
        line = new_sub_line || line
        new_sub_line = line_explode line
    end
    new_line = line_split line
  end
  line
end

def magnitude line
  return 0 unless line
  if line.to_i.to_s == line
    return line.to_i
  end
  if line[1].match(/[0-9]/)
    center = 2
    return 3 * line[1].to_i + 2 * magnitude(line[3..-2])
  else
    left_brackets = 2
    cursor = 2
    while left_brackets > 1
      left_brackets += 1 if line[cursor] == "["
      left_brackets -= 1 if line[cursor] == "]"
      cursor += 1
    end
    return 3 * magnitude(line[1..cursor-1]) + 2 * magnitude(line[cursor+1..-2])
  end
end

lines = IO.readlines("input").map{|l| l.chomp}

while lines.length > 2
  lines = [line_reduce("[#{lines[0]},#{lines[1]}]")] + lines[2..-1]
end

final_line = line_reduce "[#{lines[0]},#{lines[1]}]"
puts magnitude(final_line)

max = 0
lines = IO.readlines("input").map{|l| l.chomp}

lines.permutation(2) do |a,b|
  t = magnitude(line_reduce("[#{a},#{b}]"))
  max = t if t > max
end
puts max