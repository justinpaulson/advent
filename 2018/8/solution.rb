ARGV[0] ||= "input"

lines = IO.read(ARGV[0]).split.map(&:to_i)

def get_metadata child_count, meta_count, lines
  if child_count == 0
    return lines[0..meta_count-1], lines[meta_count..-1]
  else
    meta = []
    child_count.times do
      child_meta, lines = get_metadata(lines[0], lines[1], lines[2..-1])
      meta += child_meta
    end
    return meta + lines[0..meta_count-1], lines[meta_count..-1]
  end
end

puts get_metadata(lines[0], lines[1], lines[2..-1])[0].sum

lines = IO.read(ARGV[0]).split.map(&:to_i)

def get_value child_count, meta_count, lines
  if child_count == 0
    return lines[0..meta_count-1].sum, lines[meta_count..-1]
  else
    meta = []
    child_count.times do
      child_meta, lines = get_value(lines[0], lines[1], lines[2..-1])
      meta << child_meta
    end
    return lines[0..meta_count-1].sum{|a| (1 <= a && a < meta.length + 1) ? meta[a-1] : 0} , lines[meta_count..-1]
  end
end

puts get_value(lines[0], lines[1], lines[2..-1])[0]
