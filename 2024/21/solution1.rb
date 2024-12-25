require '../../grid.rb'
ARGV[0] ||= "input"
codes = IO.readlines(ARGV[0]).map(&:chomp)

keypad = Grid.new(4,3)
keypad.grid = [
  ["7","8","9"],
  ["4","5","6"],
  ["1","2","3"],
  [nil,"0","A"]
]

directionpad = Grid.new(2,3)
directionpad.grid = [
  [nil, "^", "A"],
  ["<", "v", ">"]
]

def get_first_sequences code
  code_array = code.split("")
  sequences = ""
  first_num = code_array.first
  case first_num
  when "0"
    sequences << "<A"
  when "1"
    sequences << "^<<A"
  when "2"
    sequences << "^<A"
    sequences << "<^A"
  when "3"
    sequences << "^A"
  when "4"
    sequences << "^^<<A"
  when "5"
    sequences << "<^^A"
  when "6"
    sequences << "^^A"
  when "8"
    sequences << "^^^<A"
    sequences << "<^^^A"
  when "9"
    sequences << "^^^A"
  else
    raise "Missing case for #{first_num}"
  end
  second_num = code_array[1]
  case [first_num, second_num]
  when ["0", "2"]
    sequences = sequences.map{|s| s += "^A"}
  when ["0", "8"]
    sequences = sequences.map{|s| s += "^^^A"}
  when ["1","4"]
    sequences = sequences.map{|s| s += "^A"}
  when ["1", "5"]
    new_sequences = []
    sequences.each do |s|
      new_sequences << s + ">^A"
      new_sequences << s + "^>A"
    end
    sequences = new_sequences
  when ["1","7"]
    sequences = sequences.map{|s| s += "^^A"}
  when ["4","5"]
    sequences = sequences.map{|s| s += ">A"}
  when ["3","7"]
    new_sequences = []
    sequences.each do |s|
      new_sequences << s + "^^<<A"
      new_sequences << s + "<<^^A"
    end
    sequences = new_sequences
  when ["2","3"]
    sequences = sequences.map{|s| s += ">A"}
  when ["5","2"]
    sequences = sequences.map{|s| s += "vA"}
  when ["6","1"]
    new_sequences = []
    sequences.each do |s|
      new_sequences << s + "v<<A"
      new_sequences << s + "<<vA"
    end
    sequences = new_sequences
  when ["6","7"]
    sequences = sequences.map{|s| s += "<<^A"}
  when ["8","9"]
    sequences = sequences.map{|s| s += ">A"}
  when ["9","6"]
    sequences = sequences.map{|s| s += "vA"}
  when ["9","7"]
    sequences = sequences.map{|s| s += "<<A"}
  when ["9","8"]
    sequences = sequences.map{|s| s += "<A"}
  else
    raise "Missing case for #{first_num}, #{second_num}"
  end
  third_num = code_array[2]
  case [second_num, third_num]
  when ["1","3"]
    sequences = sequences.map{|s| s += ">>A"}
    sequences = sequences.map{|s| s += "vA"}
  when ["3", "3"]
    sequences = sequences.map{|s| s += "A"}
    sequences = sequences.map{|s| s += "vA"}
  when ["5","6"]
    sequences = sequences.map{|s| s += ">A"}
    sequences = sequences.map{|s| s += "vvA"}
  when ["2","8"]
    sequences = sequences.map{|s| s += "^^A"}
    sequences = sequences.map{|s| s += "vvv>A"}
  when ["4","3"]
    sequences = sequences.map{|s| s += "v>>A"}
    sequences = sequences.map{|s| s += "vA"}
  when ["6","5"]
    sequences = sequences.map{|s| s += "<A"}
    sequences = sequences.map{|s| s += "vv>A"}
  when ["7","0"]
    sequences = sequences.map{|s| s += ">vvvA"}
    sequences = sequences.map{|s| s += ">A"}
  when ["7","3"]
    sequences = sequences.map{|s| s += "vv>>A"}
    sequences = sequences.map{|s| s += "vA"}
  when ["7","5"]
    new_sequences = []
    sequences.each do |s|
      new_sequences << s + "v>A"
      new_sequences << s + ">vA"
    end
    sequences = new_sequences
    new_sequences = []
    sequences.each do |s|
      new_sequences << s + "vv>A"
      new_sequences << s + ">vvA"
    end
    sequences = new_sequences
  when ["7","9"]
    sequences = sequences.map{|s| s += ">>A"}
    sequences = sequences.map{|s| s += "vvvA"}
  when ["8","0"]
    sequences = sequences.map{|s| s += "vvvA"}
    sequences = sequences.map{|s| s += ">A"}
  when ["9","4"]
    new_sequences = []
    sequences.each do |s|
      new_sequences << s + "v<<A"
      new_sequences << s + "<<vA"
    end
    sequences = new_sequences
    sequences = sequences.map{|s| s += ">>vvA"}
  else
    raise "Missing case for #{second_num}, #{third_num}"
  end

  sequences
end


def second_sequences code
  sequences = []
  code_array = code.split("")
  case code_array.first
  when "^"
    sequences << "<A"
  when "<"
    sequences << "v<<A"
    sequences << "<v<A"
  when "v"
    sequences << "v<A"
    sequences << "<vA"
  when ">"
    sequences << "vA"
  else
    raise "Missing case for #{code_array.first}"
  end
  code_array.each_cons(2) do |prev, nxt|
    if prev == nxt
      sequences = sequences.map{|s| s += "A"}
      next
    end
    case [prev, nxt]
    when ["^", "<"]
      sequences = sequences.map{|s| s += "v<A"}
    when ["^", ">"]
      new_sequences = []
      sequences.each do |s|
        new_sequences << s + "v>A"
        new_sequences << s + ">vA"
      end
      sequences = new_sequences
    when ["^", "A"]
      sequences = sequences.map{|s| s += ">A"}
    when ["<", "^"]
      sequences = sequences.map{|s| s += ">^A"}
    when ["<", "v"]
      sequences = sequences.map{|s| s += ">A"}
    when ["<", "A"]
      sequences = sequences.map{|s| s += ">>^A"}
    when [">", "^"]
      new_sequences = []
      sequences.each do |s|
        new_sequences <<  s + "<^A"
        new_sequences <<  s + "^<A"
      end
      sequences = new_sequences
    when [">", "v"]
      sequences = sequences.map{|s| s += "<A"}
    when [">", "A"]
      sequences = sequences.map{|s| s += "^A"}
    when ["v", "<"]
      sequences = sequences.map{|s| s += "<A"}
    when ["v", ">"]
      sequences = sequences.map{|s| s += ">A"}
    when ["v", "A"]
      new_sequences = []
      sequences.each do |s|
        new_sequences << s + ">^A"
        new_sequences << s + "^>A"
      end
      sequences = new_sequences
    when ["A", "^"]
      sequences = sequences.map{|s| s += "<A"}
    when ["A", "<"]
      sequences = sequences.map{|s| s += "v<<A"}
    when ["A", "v"]
      new_sequences = []
      sequences.each do |s|
        new_sequences << s + "v<A"
        new_sequences << s + "<vA"
      end
      sequences = new_sequences
    when ["A", ">"]
      sequences = sequences.map{|s| s += "vA"}
    else
      raise "Missing case for #{prev}, #{nxt}"
    end
  end

  sequences
end

def shortest_sequence code, iters
  # puts "Checking code #{code}"
  sequences = get_first_sequences(code)
  # puts "1 sequences #{sequences.count} length: #{sequences.first.length} sample: #{sequences.first}"
  iters.times do |i|
    new_sequences = []
    sequences.each do |sequence|
      new_sequences += second_sequences(sequence)
    end
    sequences = new_sequences
    # puts "#{i+2} sequences #{sequences.count} length: #{sequences.first.length} sample: #{sequences.first}"
  end
  shortest = 9999999999
  shortest_i = 0
  sequences.each_with_index do |s, i|
    if s.length < shortest
      shortest = s.length
      shortest_i = i
    end
  end
  puts "code: #{code} shortest: #{shortest} sequence: #{sequences[shortest_i]}"
  sequences[shortest_i]
end

answer = 0
codes.each do |code|
  shortest = shortest_sequence(code, 2)
  answer += shortest.length * code[0..-2].to_i
end

puts answer
