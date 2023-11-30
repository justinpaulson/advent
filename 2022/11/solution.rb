lines = IO.readlines("input")

class Monkey
  attr_accessor :test_num, :items, :operation, :true_monkey, :false_monkey

  def initialize(test_num:, items:, operation:, true_monkey:, false_monkey:)
    @test_num = test_num
    @items = items
    @operation = operation
    @true_monkey = true_monkey
    @false_monkey = false_monkey
  end


end

monkeys = []

monkeys << Monkey.new(
  test_num: 2,
  items: [84, 66, 62, 69, 88, 91, 91],
  operation: "old * 11",
  true_monkey: 4,
  false_monkey: 7
)

monkeys << Monkey.new(
  test_num: 7,
  items: [98, 50, 76, 99],
  operation: "old * old",
  true_monkey: 3,
  false_monkey: 6
)

monkeys << Monkey.new(
  test_num: 13,
  items: [72, 56, 94],
  operation: "old + 1",
  true_monkey: 4,
  false_monkey: 0
)

monkeys << Monkey.new(
  test_num: 3,
  items: [55, 88, 90, 77, 60, 67],
  operation: "old + 2",
  true_monkey: 6,
  false_monkey: 5
)

monkeys << Monkey.new(
  test_num: 19,
  items: [69, 72, 63, 60, 72, 52, 63, 78],
  operation: "old * 13",
  true_monkey: 1,
  false_monkey: 7
)

monkeys << Monkey.new(
  test_num: 17,
  items: [89, 73],
  operation: "old + 5",
  true_monkey: 2,
  false_monkey: 0
)

monkeys << Monkey.new(
  test_num: 11,
  items: [78, 68, 98, 88, 66],
  operation: "old + 6",
  true_monkey: 2,
  false_monkey: 5
)

monkeys << Monkey.new(
  test_num: 5,
  items: [70],
  operation: "old + 7",
  true_monkey: 1,
  false_monkey: 3
)

test_monkeys = []

test_monkeys << Monkey.new(
  test_num: 23,
  items: [79, 98],
  operation: "old * 19",
  true_monkey: 2,
  false_monkey: 3
)

test_monkeys << Monkey.new(
  test_num: 19,
  items: [54, 65, 75, 74],
  operation: "old + 6",
  true_monkey: 2,
  false_monkey: 0
)
test_monkeys << Monkey.new(
  test_num: 13,
  items: [79, 60, 97],
  operation: "old * old",
  true_monkey: 1,
  false_monkey: 3
)
test_monkeys << Monkey.new(
  test_num: 17,
  items: [74],
  operation: "old + 3",
  true_monkey: 0,
  false_monkey: 1
)

test_inspections = [0,0,0,0]

inspections = [0,0,0,0,0,0,0,0]

# rounds = 0
# while rounds < 20
#   monkeys.each_with_index do |monkey, i|
#     monkey.items.each do |item|
#       old = item
#       new_level = eval(monkey.operation)
#       new_level = new_level / 3
#       if new_level % monkey.test_num == 0
#         monkeys[monkey.true_monkey].items << new_level
#       else
#         monkeys[monkey.false_monkey].items << new_level
#       end
#       inspections[i] += 1
#     end
#     monkey.items = []
#   end
#   rounds += 1
# end

rounds = 0
while rounds < 10000
  monkeys.each_with_index do |monkey, i|
    monkey.items.each do |item|
      old = item
      new_level = eval(monkey.operation)
      new_level = new_level % monkeys.map{|m| m.test_num}.inject(:*)
      if new_level % monkey.test_num == 0
        monkeys[monkey.true_monkey].items << new_level
      else
        monkeys[monkey.false_monkey].items << new_level
      end
      inspections[i] += 1
    end
    monkey.items = []
  end
  rounds += 1
  puts rounds
end

p inspections.sort.reverse[0] * inspections.sort.reverse[1]
