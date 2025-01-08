require 'digest'
ARGV[0] ||= "input"
line = IO.read(ARGV[0]).chomp
0.upto(9999999) do |i|
  if (Digest::MD5.hexdigest(line + i.to_s)).start_with?("00000")
    p i
    break
  end
end
0.upto(9999999) do |i|
  if (Digest::MD5.hexdigest(line + i.to_s)).start_with?("000000")
    p i
    break
  end
end
