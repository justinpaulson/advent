require '../../grid.rb'
ARGV[0] ||= "input"
line = IO.read(ARGV[0]).chomp

stones = line.split(" ").map(&:to_i)

def split_stone stone
  stone = stone.to_s
  [stone[0..(stone.length/2)-1].to_i, stone[(stone.length/2)..-1].to_i]
end

class Integer
  def split_stone
    stone = self.to_s
    [stone[0..(stone.length/2)-1].to_i, stone[(stone.length/2)..-1].to_i]
  end

  def blink
    if self.to_s.chars.length.even?
      split_stone
    else
      (self * 2024)
    end
  end
end

stone_dict = {}
stones.group_by{|a| a}.map do |s, indexes|
  stone_dict[s] = indexes.length
end

stones = stone_dict

@blink_cache = {0=>1} # VERY IMPORTANT TO CACHE 0
75.times do |i|
  new_stones = Hash.new(0)
  stones.each do |stone, count|
    @blink_cache[stone] ||= stone.blink
    if @blink_cache[stone].is_a? Array
      new_stones[@blink_cache[stone][0]] += count
      new_stones[@blink_cache[stone][1]] += count
    else
      new_stones[@blink_cache[stone]] ||= 0
      new_stones[@blink_cache[stone]] += count
    end
  end
  stones = new_stones
  puts stones.values.sum if i == 24
end

puts stones.values.sum
