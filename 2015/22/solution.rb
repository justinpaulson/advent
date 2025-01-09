require '../../grid.rb'
ARGV[0] ||= "input"
boss_stats = File.readlines(ARGV[0]).map{ |line| line.split(": ")[1].to_i }

@wizard = { hp: 50, mana: 500, armor: 0 }
@boss = { hp: boss_stats[0], damage: boss_stats[1] }

# test_1
if ARGV[0] == "test1"
  @wizard = { hp: 10, mana: 250, armor: 0 }
end

if ARGV[0] == "test2"
  @wizard = { hp: 10, mana: 250, armor: 0 }
end

# [[3,0], {:hp=>-14, :mana=>656, :armor=>0}, {:hp=>8, :damage=>8}]=>402
# [[3], {:hp=>2, :mana=>77, :armor=>0}, {:hp=>7, :damage=>8}]=>173

@spells = [
  { cost: 53, turns: 1, armor: 0, damage: 4, mana: 0, hp: 0, delay: 0 },
  { cost: 73, turns: 1, armor: 0, damage: 2, mana: 0, hp: 2, delay: 0 },
  { cost: 113, turns: 6, armor: 7, damage: 0, mana: 0, hp: 0, delay: 0 },
  { cost: 173, turns: 6, armor: 0, damage: 3, mana: 0, hp: 0, delay: 1 },
  { cost: 229, turns: 5, armor: 0, damage: 0, mana: 101, hp: 0, delay: 1 }
]

# each turn a wizard must select one spell to cast
# the spell will be cast immediately and will then
# take effect on each turn until the number of :turns
# defined in the spell has passed
#
# use A* to find the least number of mana the wizard
# the wizard can spend and still win

@all_paths = []

def apply_path path, wizard, boss
  last_spell = @spells[path.last]
  previous_spell = path.length > 1 ? @spells[path[-2]] : nil
  two_spells_ago = path.length > 2 ? @spells[path[-3]] : nil
  three_spells_ago = path.length > 3 ? @spells[path[-4]] : nil

  # wizard[:mana] -= last_spell[:cost]
  wizard[:hp] += last_spell[:hp]
  boss[:hp] -= last_spell[:damage] if last_spell[:turns] == 1

  # Turn 1, Boss Turn
  wizard[:armor] += last_spell[:armor]
  wizard[:armor] -= three_spells_ago[:armor] if three_spells_ago
  wizard[:mana] += last_spell[:mana]
  wizard[:mana] += previous_spell[:mana] if previous_spell
  wizard[:mana] += two_spells_ago[:mana] if two_spells_ago
  boss[:hp] -= last_spell[:damage] if last_spell[:turns] > 1
  boss[:hp] -= previous_spell[:damage] if previous_spell && previous_spell[:turns] > 1
  boss[:hp] -= two_spells_ago[:damage] if two_spells_ago && two_spells_ago[:turns] > 1
  return [wizard, boss] if boss[:hp] <= 0

  wizard[:hp] -= (boss[:damage] - wizard[:armor] > 1 ? boss[:damage] - wizard[:armor] : 1)

  # Turn 2, Wizard Turn
  if @hard
    wizard[:hp] -= 1
    return [wizard, boss] if wizard[:hp] <= 0
  end

  wizard[:mana] += last_spell[:mana]
  wizard[:mana] += previous_spell[:mana] if previous_spell
  boss[:hp] -= last_spell[:damage] if last_spell[:turns] > 1
  boss[:hp] -= previous_spell[:damage] if previous_spell && previous_spell[:turns] > 1
  boss[:hp] -= two_spells_ago[:damage] if two_spells_ago && two_spells_ago[:turns] > 1

  # puts "Wizard: #{wizard}, Boss: #{boss}"
  [wizard, boss]
end

def is_goal? point
  point[2][:hp] <= 0 && point[1][:hp] > 0
end

def get_neighbors point
  curr_path = point[0]
  curr_wizard = point[1]
  curr_boss = point[2]

  return [] if curr_wizard[:hp] <= 0
  return [] if curr_boss[:hp] <= 0

  active_spells = curr_path[1..-1]

  spell_indexes = []
  @spells.each_with_index do |spell, i|
    next if curr_wizard[:mana] < spell[:cost]
    next if active_spells&.include?(i) && @spells[i][:turns] != 1
    spell_indexes << i
  end

  neighbors = []
  spell_indexes.each do |i|
    current_spell = @spells[i]

    tent_wizard = curr_wizard.clone
    tent_boss = curr_boss.clone
    tent_path = (curr_path + [i]).last(4)

    tent_wizard[:mana] -= current_spell[:cost]
    tent_wizard, tent_boss = apply_path(tent_path, tent_wizard, tent_boss)

    neighbors << [tent_path, tent_wizard, tent_boss] if tent_wizard[:hp] > 0
  end

  neighbors
end

def score_for_neighbor point, neighbor
  @spells[neighbor[0].last][:cost]
end

def h point
  # return 0
  return 0 if point[0].empty?
  point[2][:hp] - point[1][:hp] - point[1][:armor]
end

def print_a_star curr_point, lowest, neighbors, set, from, g, f
  # return
  # puts "Lowest: #{lowest}, Boss HP: #{curr_point[2][:hp]}"
  # puts "neighbors: #{neighbors}"
  # puts "set: #{set}"
  # key_wait
  # puts "g: #{g}"
  # puts "curr_point: #{curr_point}"
  # puts "lowest: #{lowest}"
  # puts "from: #{from}"
  # puts "f: #{f}"
  # key_wait
end

# bit slow, could speed up the a* probably
@hard = false
start = [[], @wizard.clone, @boss.clone]
p a_star(start, h_path: false, neighbors_path: false).last

@wizard[:hp] -= 1
@hard = true

start = [[], @wizard.clone, @boss.clone]
p a_star(start, h_path: false, neighbors_path: false).last
