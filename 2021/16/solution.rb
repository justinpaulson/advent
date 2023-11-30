@input = IO.read("input").chomp

class Packet

  attr_accessor :version, :type, :cursor, :subpackets, :length, :value

  def initialize(version, type, cursor, packets=[])
    @version = version.to_i(2)
    @type = type
    @cursor = cursor
    @subpackets = packets
    @length = 0
    @value = nil
  end

  def to_s
    "Version: #{@version}, Type: #{@type}, Cursor: #{@cursor}, Length: #{@length}"
  end
end

cursor = 0


@binary_input = @input.to_i(16).to_s(2)

case @input[0]
when "0"
  @binary_input = "0000" + @binary_input
when "1"
  @binary_input = "000" + @binary_input
when "2", "3"
  @binary_input = "00" + @binary_input
when "4", "5", "6", "7"
  @binary_input = "0" + @binary_input
end

puts @binary_input

@packets = []

def find_packet cursor
  if cursor > @binary_input.length - 3
    return nil
  end
  version = @binary_input[cursor..cursor+2]
  type_id = @binary_input[cursor+3..cursor+5]
  type = type_id.to_i(2)
  packet = Packet.new(version, type, cursor)
  @packets << packet  if !@packets.map(&:cursor).include?(packet.cursor)
  new_cursor = 0
  if type == 4
    new_cursor += 6
    while @binary_input[cursor + new_cursor] != '0'
      new_cursor += 5
    end
    new_cursor += 5
    packet.length = new_cursor
  else
    bit = @binary_input[cursor+6]
    new_cursor += 7
    sub_length = 0
    if bit == "0"
      sub_length = (@binary_input[cursor+7..cursor+21]).to_i(2)
      new_cursor += 15
      lengths = 0
      while lengths < sub_length
        sub_packet = find_packet(cursor+new_cursor+lengths)
        if sub_packet
          packet.subpackets << sub_packet
          @packets << sub_packet if !@packets.map(&:cursor).include?(sub_packet.cursor)
          lengths += sub_packet.length
        else
          lengths += 10
        end
      end
      packet.length = new_cursor + sub_length
    elsif bit == "1"
      packet_count = (@binary_input[cursor+7..cursor+17]).to_i(2)
      new_cursor += 11
      packets_found = 0
      while packets_found < packet_count
        packets_found += 1
        sub_packet = find_packet(cursor + new_cursor)
        if sub_packet
          packet.subpackets << sub_packet
          @packets << sub_packet if !@packets.map(&:cursor).include?(sub_packet.cursor)
          new_cursor += sub_packet.length
        end
      end
      packet.length = new_cursor
    end
  end
  packet
end

find_packet 0

puts @packets.sum{|pack| pack.version}

while @packets.any?{|pack| pack.value == nil}
  @packets.each do |pack|
    puts pack
    case pack.type
    when 4
      pieces = (pack.length - 6)/5
      bin_val = ""
      0.upto(pieces-1) do |i|
        bin_val += @binary_input[pack.cursor+7+i*5..pack.cursor+7+i*5+3] 
      end
      pack.value = bin_val.to_i(2)
      puts pack.value
    when 0
      pack.value = pack.subpackets.sum{|sp| sp.value} unless pack.subpackets.any?{|sp| sp.value.nil?}
    when 1
      pack.value = pack.subpackets.inject(1){|prev, sp| prev * sp.value} unless pack.subpackets.any?{|sp| sp.value.nil?}
    when 2
      pack.value = pack.subpackets.map{|sp| sp.value}.min unless pack.subpackets.any?{|sp| sp.value.nil?}
    when 3
      pack.value = pack.subpackets.map{|sp| sp.value}.max unless pack.subpackets.any?{|sp| sp.value.nil?}
    when 5
      pack.value = pack.subpackets[0].value > pack.subpackets[1].value ? 1 : 0 unless pack.subpackets.any?{|sp| sp.value.nil?}
    when 6
      pack.value = pack.subpackets[0].value < pack.subpackets[1].value ? 1 : 0 unless pack.subpackets.any?{|sp| sp.value.nil?}
    when 7
      pack.value = pack.subpackets[0].value == pack.subpackets[1].value ? 1 : 0 unless pack.subpackets.any?{|sp| sp.value.nil?}
    end
  end
end

puts @packets.first.value


# 89358450808876362509   too high