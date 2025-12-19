require '../../grid.rb'
require 'z3'

ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

def is_goal? point
  point == @current_goal
end

def get_neighbors state, path=[]
  neighbors = []
  @current_buttons.each_with_index do |button, index|
    new_state = state.dup
    button.each do |char_index|
      new_state[char_index] = state[  char_index] == "." ? "#" : "."
    end
    neighbors << new_state
  end
  neighbors
end

def score_for_neighbor state, neighbor
  1
end

def h point, path=[]
  1
end

total_part_1 = 0
total_part_2 = 0
lines.each_with_index do |line, index|
  goal, buttons = line.split("] (")
  goal = goal[1..-1]
  @current_goal = goal
  buttons = buttons.split(") (")
  buttons[-1], goal_2 = buttons[-1].split(")")
  buttons.map!{|button| button.split(",").map(&:to_i)}
  @current_buttons = buttons.dup
  result = a_star("."*goal.length, h_path: false)
  button_presses = result[-1]
  total_part_1 += button_presses

  @current_goal = goal_2.gsub("{","").gsub("}","").split(",").map(&:to_i)
  coeffs = []
  sums = []
  @current_goal.each_with_index do |goal_value, index|
    coeffs << buttons.map{|button| button.include?(index) ? 1 : 0}
    sums << goal_value
  end

  solver = Z3::Optimize.new

  vars = []

  coeffs[0].length.times do |i|
    vars << Z3.Int("v#{i}")
    solver.assert(vars[-1] >= 0)
  end

  sums.each_with_index do |sum, row_index|
    variables = coeffs[row_index].each_with_index.map do |coeff, col_index|
      coeff == 0 ? coeff : vars[col_index]
    end.sum
    solver.assert(variables == sum)
  end

  solver.minimize(vars.reduce(:+))

  solver.check

  model = solver.model

  total_part_2 += vars.sum{|var| model[var].to_i}
end

puts total_part_1
puts total_part_2
