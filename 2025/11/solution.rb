require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

@nodes = {}

lines.each do |line|
  name, edges = line.split(": ")
  edges = edges.split(" ")
  @nodes[name] = edges
end

def paths_to_out(path)
  current = path.last
  if current == 'out'
    @out_paths << path
    return path
  end
  return nil unless @nodes[current]
  (@nodes[current] - path).each do |next_node|
    new_path = path.dup
    new_path << next_node
    paths_to_out(new_path)
  end
  nil
end

@out_paths = []
paths_to_out(['you'])
puts @out_paths.uniq.size

@paths_to_target_cache = {}
def paths_to_target(current, target, skipping=nil)
  cache_key = [current, target, skipping].join("->")
  if @paths_to_target_cache[cache_key]
    return @paths_to_target_cache[cache_key]
  end
  return 0 unless @nodes[current]
  return_val = 0
  (@nodes[current]).each do |next_node|
    next if skipping && next_node == skipping
    if next_node == target
      return_val += 1
      next
    end
    return_val += paths_to_target(next_node, target, skipping)
  end
  @paths_to_target_cache[cache_key] = return_val
  return_val
end

fft_out = paths_to_target('fft', 'out', 'dac')
dac_out = paths_to_target('dac', 'out', 'fft')
fft_to_dac = paths_to_target('fft', 'dac')
dac_to_fft = paths_to_target('dac', 'fft')
svr_to_fft = paths_to_target('svr', 'fft', 'dac')
svr_to_dac = paths_to_target('svr', 'dac', 'fft')

results = (svr_to_fft * fft_to_dac * dac_out)
results += (svr_to_dac * dac_to_fft * fft_out)

puts results
