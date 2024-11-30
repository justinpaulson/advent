require 'set'

molecule = "CRnCaSiRnBSiRnFArTiBPTiTiBFArPBCaSiThSiRnTiBPBPMgArCaSiRnTiMgArCaSiThCaSiRnFArRnSiRnFArTiTiBFArCaCaSiRnSiThCaCaSiRnMgArFYSiRnFYCaFArSiThCaSiThPBPTiMgArCaPRnSiAlArPBCaCaSiRnFYSiThCaRnFArArCaCaSiRnPBSiRnFArMgYCaCaCaCaSiThCaCaSiAlArCaCaSiRnPBSiAlArBCaCaCaCaSiThCaPBSiThPBPBCaSiRnFYFArSiThCaSiRnFArBCaCaSiRnFYFArSiThCaPBSiThCaSiRnPMgArRnFArPTiBCaPRnFArCaCaCaCaSiRnCaCaSiRnFYFArFArBCaSiThFArThSiThSiRnTiRnPMgArFArCaSiThCaPBCaSiRnBFArCaCaPRnCaCaPMgArSiRnFYFArCaSiThRnPBPMgAr"

@lines = IO.readlines("input").map{|l| l.chomp.split(" => ")}

moles = Set.new

@lines.each do |(from, to)|
  molecule.scan(/#{from}/) do |c|
    mole = molecule[0..Regexp.last_match.offset(0).first-1] + to + molecule[Regexp.last_match.offset(0).first+from.length..-1]
    moles.add(mole)
  end
end

puts moles.count

new_mole = "e"

require '../../grid.rb'

def is_goal? point
  point == "e"
end

def get_neighbors point
  neighbors = []

  @lines.each do |(to, from)|
    point.scan(/#{from}/) do |c|
      neighbors << point[0..Regexp.last_match.offset(0).first-1] + to + point[Regexp.last_match.offset(0).first+from.length..-1]
    end
  end

  neighbors
end

def score_for_neighbor point, neighbor
  1
end

def h point
  total = point.length
  total += 33 * point.scan(/HF|NAl|OMg/).length
  total += 10 * point.scan(/BF|TiMg|CrnFYFAr|CRnMgAr|HP|NRnFAr|OTi|PMg/).length
  total += 8 * point.scan(/SiRnFAr|SiRnMgAr|SiTh|CaCa|PB|PRnFAr|CaSi/).length
  total
end

def print_a_star curr_point, lowest, neighbors, set, from, g, f
  puts "#{lowest} => #{curr_point}"
end

# puts a_star(molecule)

count = 0
iters = 0
while molecule != 'e'
  @lines.each do |(to, from)|
    iters += 1
    new_molecule = molecule.sub(from, to)
    puts new_molecule
    if (new_molecule) != molecule
      molecule = new_molecule
      count += 1
    end
  end
end

puts iters
puts count
