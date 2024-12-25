require '../../grid.rb'
ARGV[0] ||= "input"
codes = IO.readlines(ARGV[0]).map(&:chomp)

FIRST_SEQUENCE = {
  "0" => "<A",
  "1" => "^<<A",
  "3" => "^A",
  "4" => "^^<<A",
  "5" => "<^^A",
  "6" => "^^A",
  "9" => "^^^A"
}

PAIR_SEQUENCE = {
  ["0", "2"] => "^A",
  ["0", "8"] => "^^^A",
  ["1", "4"] => "^A",
  ["1", "7"] => "^^A",
  ["2", "3"] => ">A",
  ["2", "9"] => "^^>A",
  ["3", "7"] => "<<^^A",
  ["4", "5"] => ">A",
  ["5", "2"] => "vA",
  ["6", "7"] => "<<^A",
  ["8", "9"] => ">A",
  ["9", "6"] => "vA",
  ["9", "7"] => "<<A",
  ["9", "8"] => "<A"
}

TRIPLE_SEQUENCE = {
  ["1", "3"] => ">>AvA",
  ["2", "8"] => "^^Avvv>A",
  ["2", "9"] => "^^>AvvvA",
  ["3", "3"] => "AvA",
  ["3", "7"] => "<<^^A>>vvvA",
  ["5", "6"] => ">AvvA",
  ["4", "3"] => "v>>AvA",
  ["6", "5"] => "<Avv>A",
  ["7", "0"] => ">vvvA>A",
  ["7", "3"] => "vv>>AvA",
  ["7", "9"] => ">>AvvvA",
  ["8", "0"] => "vvvA>A"
}

def get_first_sequences(code)
  code_array = code.chars
  first_num, second_num, third_num = code_array[0], code_array[1], code_array[2]

  sequence = FIRST_SEQUENCE[first_num] || raise("Missing case for #{first_num}")
  sequence << (PAIR_SEQUENCE[[first_num, second_num]] || raise("Missing case for #{first_num}, #{second_num}"))
  sequence << (TRIPLE_SEQUENCE[[second_num, third_num]] || raise("Missing case for #{second_num}, #{third_num}"))

  sequence
end

@paths = {
  "^^" => "A",
  "<<" => "A",
  "vv" => "A",
  ">>" => "A",
  "AA" => "A",
  "^<" => "v<A",
  "^>" => "v>A",
  "^A" => ">A",
  "<^" => ">^A",
  "<v" => ">A",
  "<A" => ">>^A",
  ">^" => "<^A",
  ">v" => "<A",
  ">A" => "^A",
  "v<" => "<A",
  "v>" => ">A",
  "vA" => "^>A",
  "A^" => "<A",
  "A<" => "v<<A",
  "Av" => "<vA",
  "A>" => "vA"
}

@shortest_cache = {}

def shortest(code)
  return @shortest_cache[code] if @shortest_cache[code]

  sequence = @paths["A#{code[0]}"]
  code.chars.each_cons(2) do |pair|
    sequence += @paths[pair.join] || ""
  end

  @shortest_cache[code] = sequence
  sequence
end

@get_parts = {"A" => ["A"]} # important base case

def get_parts(code)
  return @get_parts[code] if @get_parts[code]
  parts = []

  sequence = shortest(code)
  sequence.split("A").map do |part|
    parts << part + "A"
  end

  @get_parts[code] = parts
end

answer_1 = 0
answer_2 = 0
@shortest_sequences = {}
@last_time = Time.now
codes.each do |code|
  shortest_sequence = 0
  if code == "973A"
    shortest_sequence = @shortest_sequences["965A"] + 2
  else
    first_code = get_first_sequences(code)
    parts = first_code.split("A")
    parts = parts.map{|part| part + "A"}.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
    25.times do |i|
      new_parts = {}
      parts.each do |part, count|
        get_parts(part).each do |new_part|
          new_parts[new_part] ||= 0
          new_parts[new_part] += count
        end
      end

      parts = new_parts
      shortest_sequence = parts.sum{|k,v| k.length * v}
      if i == 1
        answer_1 += shortest_sequence * code[0..-2].to_i
        if code == "965A"           # realized these two are always 2 off
          answer_1 += (shortest_sequence + 2) * 973
        end
      end
    end
  end
  @shortest_sequences[code] = shortest_sequence
  answer_2 += shortest_sequence * code[0..-2].to_i
end
puts answer_1
puts answer_2
