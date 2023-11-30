sues = IO.readlines("input").map{|l| l.chomp.split(/[0-9]: /)[1].split(", ").map{|attr| attr.split(": ").each_with_index.map{|a, i| i == 0 ? a : a.to_i}}.to_h}

sue = {
  "children" => 3,
  "cats" => 7,
  "samoyeds" => 2,
  "pomeranians" => 3,
  "akitas" => 0,
  "vizslas" => 0,
  "goldfish" => 5,
  "trees" => 3,
  "cars" => 2,
  "perfumes" => 1
}

sue_index = nil
sues.each do |sue_check|
  pass = true
  sue_check.each do |k,v|
    pass = false if sue[k] != v
  end
  sue_index = sues.index(sue_check) if pass
end

puts sue_index+1

sue_index = nil
da_sue = sues.each_with_index.select do |s, i|
  pass = true
  sue.each do |k, v|
    if k== "cats" || k=="trees"
      pass = false if s[k] && s[k] <= v
    elsif k=="pomeranians" || k=="goldfish"
      pass = false if s[k] && s[k] >= v
    else
      pass = false if s[k] && s[k] != v
    end
  end
  sue_index = sues.index(s) if pass
  pass
end

puts sue_index+1