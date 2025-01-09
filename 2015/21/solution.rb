ARGV[0] ||= "input"
boss_stats = File.readlines(ARGV[0]).map{ |line| line.split(": ")[1].to_i }

boss = { hp: boss_stats[0], damage: boss_stats[1], armor: boss_stats[2] }

me = { hp: 100, damage: 0, armor: 0}

# must select 1
weapons = [
  { cost: 8, damage: 4, armor: 0 },
  { cost: 10, damage: 5, armor: 0 },
  { cost: 25, damage: 6, armor: 0 },
  { cost: 40, damage: 7, armor: 0 },
  { cost: 74, damage: 8, armor: 0 }
]

# can select 0 - 1
armors = [
  { cost: 13, damage: 0, armor: 1 },
  { cost: 31, damage: 0, armor: 2 },
  { cost: 53, damage: 0, armor: 3 },
  { cost: 75, damage: 0, armor: 4 },
  { cost: 102, damage: 0, armor: 5 }
]

# can select 0 - 2
rings = [
  { cost: 25, damage: 1, armor: 0 },
  { cost: 50, damage: 2, armor: 0 },
  { cost: 100, damage: 3, armor: 0 },
  { cost: 20, damage: 0, armor: 1 },
  { cost: 40, damage: 0, armor: 2 },
  { cost: 80, damage: 0, armor: 3 }
]

def winner(player_1, player_2)
  player_1_hp = player_1[:hp]
  player_2_hp = player_2[:hp]
  player_1_damage = player_1[:damage]
  player_2_damage = player_2[:damage]
  player_1_armor = player_1[:armor]
  player_2_armor = player_2[:armor]

  while true
    player_2_hp -= [1, player_1_damage - player_2_armor].max
    return player_1 if player_2_hp <= 0
    player_1_hp -= [1, player_2_damage - player_1_armor].max
    return player_2 if player_1_hp <= 0
  end
end

# find the least amount of cost that will cause me to win over the boss
# part 1
min_cost = 999999
max_cost = 0
weapons.each do |weapon|
  armor = {cost: 0, damage: 0, armor: 0}
  ring_1 = {cost: 0, damage: 0, armor: 0}
  ring_2 = {cost: 0, damage: 0, armor: 0}
  0.upto(6) do |armor_index|
    armor = armors[armor_index] if armor_index < armors.length
    0.upto(7) do |ring1_index|
      ring_1 = rings[ring1_index] if ring1_index < rings.length
      0.upto(7) do |ring2_index|
        ring_2 = rings[ring2_index] if ring2_index < rings.length
        cost = weapon[:cost] + armor[:cost] + ring_1[:cost] + ring_2[:cost]

        me = { hp: me[:hp], damage: weapon[:damage] + ring_1[:damage] + ring_2[:damage], armor: armor[:armor] + ring_1[:armor] + ring_2[:armor] }

        if winner(me, boss) == me
          if cost < min_cost
            min_cost = cost
          end
        else
          if cost > max_cost
            max_cost = cost
          end
        end
      end
    end
  end
end

puts min_cost
puts max_cost
