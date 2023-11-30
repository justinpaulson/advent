lines = IO.readlines("input")

puts (lines.map do |line|
  first = line[0..line.length/2-1]
  second = line[line.length/2..-1]
  priority = 0
  second.chars.each do |char|
    if first.chars.include?(char)
      if char.upcase == char
        priority = char.ord - "A".ord + 27
      else
        priority = char.ord - "a".ord + 1
      end
    end
  end
  priority
end).sum


puts (lines.each_slice(3).map do |first,second,third|
  puts first
  puts second
  puts third
  first = first.chomp
  second = second.chomp
  third = third.chomp
  priority = 0
  second.chars.each do |char|
    if first.chars.include?(char)
      if third.chars.include?(char)
        if char.upcase == char
          priority = char.ord - "A".ord + 27
        else
          priority = char.ord - "a".ord + 1
        end
        puts first
        puts second
        puts third
        puts char
        puts priority
      end
    end
  end
  priority
end).sum

