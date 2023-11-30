lines = IO.readlines("input").map{|l| l.split(" | ").map{|p| p.split.map{|t| t.chars.sort.join}}}

puts lines.sum{|l| l[1].sum{|i| i.length == 2 || i.length == 3 || i.length == 4 || i.length == 7 ? 1 : 0}}

@sorted_nums = ["abcdefg", "abcdfg", "abcefg", "abdefg", "abdfg", "acdeg", "acdfg", "acf", "bcdf", "cf"]

@nums_index_value = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]

def solves? line, test
  o = line[0].map do |num|
    num.chars.map{|c| ("a".ord + test.index(c)).chr}.sort.join
  end.sort 
  o == @sorted_nums
end

def total line, test
  line[1].map do |num|
    @nums_index_value.index(num.chars.map{|c| ("a".ord + test.index(c)).chr}.sort.join)
  end.join.to_i
end

t = lines.each_with_index.map do |line, i|
  output = line[1]
  input = line[0]
  all = output + input
  a,b,c,d,e,f,g = Array.new(7) { ["a","b","c","d","e","f","g"] }

  all.each do |digits|
    if digits.length == 2
      c = c & digits.chars
      f = f & digits.chars
      a = a - digits.chars
      b = b - digits.chars
      d = d - digits.chars
      e = e - digits.chars
      g = g - digits.chars
    elsif digits.length == 3
      a = a & digits.chars
      c = c & digits.chars
      f = f & digits.chars
      b = b - digits.chars
      d = d - digits.chars
      e = e - digits.chars
      g = g - digits.chars
    elsif digits.length == 4
      b = b & digits.chars
      c = c & digits.chars
      d = d & digits.chars
      f = f & digits.chars
      a = a - digits.chars
      e = e - digits.chars
      g = g - digits.chars
    end  
  end
  tests = [[a[0],b[0],c[0],d[1],e[0],f[1],g[1]],
  [a[0],b[0],c[0],d[1],e[1],f[1],g[0]],
  [a[0],b[0],c[1],d[1],e[0],f[0],g[1]],
  [a[0],b[0],c[0],d[1],e[0],f[1],g[1]],
  [a[0],b[1],c[0],d[0],e[0],f[1],g[1]],
  [a[0],b[1],c[0],d[0],e[1],f[1],g[0]],
  [a[0],b[1],c[1],d[0],e[0],f[0],g[1]],
  [a[0],b[1],c[0],d[0],e[0],f[1],g[1]]]

  out = 999999999999999999
  
  "abcdefg".split('').permutation.each_with_index do |t|
    out = total(line, t) if solves?(line, t)
  end

  out
end.sum

p t 
