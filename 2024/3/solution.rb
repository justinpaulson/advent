require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

total = 0

lines.each do |line|
  line.scan(/mul\([0-9]+,[0-9]+\)/) do |m|
    m, n = m.to_s.split('mul(')[1].split(',').map(&:to_i)
    total += m * n
  end
end

puts total

class String
  def indices e
    start, result = -1, []
    result << start while start = (self.index e, start + 1)
    result
  end
end

total = 0
on = true
lines.each do |line|
  donts = line.indices('don\'t()')
  dos = line.indices('do()')
  mults = line.indices(/mul\([0-9]+,[0-9]+\)/)

  0.upto(line.length-1) do |i|
    if donts.include? i
      on = false
    elsif dos.include? i
      on = true
    end
    if mults.include?(i)
      m, n = line[i..-1].scan(/mul\([0-9]+,[0-9]+\)/).first.to_s.split('mul(')[1].split(',').map(&:to_i)
      total += m * n if on
    end
  end
end

puts total
