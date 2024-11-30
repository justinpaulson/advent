require '../../grid.rb'
ARGV[0] ||= "input"
input = IO.read(ARGV[0]).strip

grid = []

grid << input

@next_line = {}

def next_line line
  return @next_line[line] if @next_line[line]
  new_line = ""
  0.upto(line.length-1) do |x|
    check = ""
    if x == 0
      check = "." + line[x..(x+1)]
    elsif x == line.length - 1
      check = line[(x-1)..x] + "."
    else
      check = line[(x-1)..(x+1)]
    end
    new_line << (["^^.", ".^^", "^..", "..^"].include?(check) ? "^" : ".")
  end
  @next_line[line] = new_line
end

1.upto(399999) do |y|
  grid << next_line(grid[y-1])
end

puts grid[0..39].map { |row| row.count(".") }.reduce(:+)
puts grid.map { |row| row.count(".") }.reduce(:+)
