require 'set'
ARGV[0] = "input"

@lines, molecule = IO.read(ARGV[0]).split("\n\n")
@lines = @lines.split("\n").map{|l| l.chomp.split(" => ")}

moles = Set.new

@lines.each do |(from, to)|
  molecule.scan(/#{from}/) do |c|
    mole = molecule[0..Regexp.last_match.offset(0).first-1] + to + molecule[Regexp.last_match.offset(0).first+from.length..-1]
    moles.add(mole)
  end
end

puts moles.count

new_mole = "e"

count = 0
iters = 0
while molecule != 'e'
  @lines.each do |(to, from)|
    iters += 1
    new_molecule = molecule.sub(from, to)
    if (new_molecule) != molecule
      molecule = new_molecule
      count += 1
    end
  end
end

puts count
