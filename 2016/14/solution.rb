require '../../grid.rb'
ARGV[0] ||= "input"

require 'digest'

input = "qzyelonm"

index = 0

keys = []

hashes = {}

def generate_hash input, index
  #part 1
  output = Digest::MD5.hexdigest("#{input}#{index}")

  #part 2
  2016.times do
    output = Digest::MD5.hexdigest(output)
  end

  output
end

while keys.length < 64
  hashes[index] = generate_hash(input, index)
  if hashes[index] =~ /(.)\1\1/
    char = $1
    (1..1000).each do |i|
      hashes[index + i] ||= generate_hash(input, index + i)
      if hashes[index + i] =~ /#{char}{5}/
        keys << index
        break
      end
    end
  end
  index += 1
end

puts index - 1
