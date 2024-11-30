require '../../grid.rb'
ARGV[0] ||= "input"
max_recipes = IO.read(ARGV[0]).to_i

recipes = [3, 7]
elf1 = 0
elf2 = 1

while recipes.length < 21000000
  sum = recipes[elf1] + recipes[elf2]
  recipes.push(1) if sum >= 10
  recipes.push(sum % 10)
  elf1 = (elf1 + recipes[elf1] + 1) % recipes.length
  elf2 = (elf2 + recipes[elf2] + 1) % recipes.length
end

max_recipes_string = max_recipes.to_s

recipes = recipes.map!(&:to_s).join

while !(index = recipes.index(max_recipes_string))
  sum = recipes[elf1].to_i + recipes[elf2].to_i
  recipes += sum.to_s
  elf1 = (elf1 + recipes[elf1].to_i + 1) % recipes.length
  elf2 = (elf2 + recipes[elf2].to_i + 1) % recipes.length
end

puts recipes[max_recipes..max_recipes+9]
puts index
