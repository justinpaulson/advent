lines = IO.read("input").chomp

lines = lines.chars

# lines = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>".chars

require "../../grid"

grid = new_grid 1000000, 7, false
rock_types = ["-", "+", "J", "I", "o"]
@rock_width = {
  "-": 4,
  "+": 3,
  "J": 3,
  "o": 2,
  "I": 1
}
@rock_height = {
  "-": 1,
  "+": 3,
  "J": 3,
  "o": 2,
  "I": 4
}

def can_move grid, rock, left, bottom, dir
  if dir == ">"
    return false if left == (7 - @rock_width[rock.to_sym])

    case rock
    when "I"
      return grid[bottom][left + 1] == false && grid[bottom+1][left + 1] == false && grid[bottom+2][left + 1] == false && grid[bottom+3][left + 1] == false
    when "o"
      return grid[bottom][left + 2] == false && grid[bottom+1][left + 2] == false
    when "+"
      return grid[bottom][left + 2] == false && grid[bottom+1][left + 3] == false && grid[bottom+2][left + 2] == false
    when "J"
      return grid[bottom][left + 3] == false && grid[bottom+1][left + 3] == false && grid[bottom+2][left + 3] == false
    when "-"
      return grid[bottom][left + 4] == false
    end
  else
    return false if left == 0

    case rock
    when "I"
      return grid[bottom][left - 1] == false && grid[bottom+1][left - 1] == false && grid[bottom+2][left - 1] == false && grid[bottom+3][left - 1] == false
    when "o"
      return grid[bottom][left - 1] == false && grid[bottom+1][left - 1] == false
    when "+"
      return grid[bottom][left] == false && grid[bottom+1][left - 1] == false && grid[bottom+2][left] == false
    when "J"
      return grid[bottom][left - 1] == false && grid[bottom+1][left + 1] == false && grid[bottom+2][left + 1] == false
    when "-"
      return grid[bottom][left - 1] == false
    end
  end
end

def can_drop grid, rock, left, bottom
  return false if bottom == 0
  case rock
  when "I"
    return grid[bottom - 1][left] == false
  when "o"
    return grid[bottom - 1][left] == false && grid[bottom - 1][left + 1] == false
  when "+"
    return grid[bottom][left] == false && grid[bottom - 1][left + 1] == false && grid[bottom][left + 2] == false
  when "J"
    return grid[bottom - 1][left] == false && grid[bottom - 1][left + 1] == false && grid[bottom - 1][left + 2] == false
  when "-"
    return grid[bottom - 1][left..left+3] == [false,false,false,false]
  end
end

def draw_rock grid, rock, left, bottom
  # puts "left: #{left}, bottom: #{bottom}"
  case rock
  when "I"
    grid[bottom][left] = true
    grid[bottom+1][left] = true
    grid[bottom+2][left] = true
    grid[bottom+3][left] = true
  when "o"
    grid[bottom][left] = true
    grid[bottom+1][left] = true
    grid[bottom][left+1] = true
    grid[bottom+1][left+1] = true
  when "+"
    grid[bottom][left+1] = true
    grid[bottom+1][left] = true
    grid[bottom+1][left+1] = true
    grid[bottom+1][left+2] = true
    grid[bottom+2][left+1] = true
  when "J"
    grid[bottom][left] = true
    grid[bottom][left+1] = true
    grid[bottom][left+2] = true
    grid[bottom+1][left+2] = true
    grid[bottom+2][left+2] = true
  when "-"
    grid[bottom][left..left+3] = [true,true,true,true]
  end
  grid
end

def reset_bottom grid, row
  out_grid = new_grid grid.length, 7, false
  (row+1).upto(grid.length-1) do |i|
    out_grid[i-row-1] == grid[i]
  end
  out_grid
end

# total_height = 1547953193511
top_rock = 9
# grid_offset = 6 - top_rock
# rocks = 15390 * 64977257
rocks = 999999985230
current = 10057
top_rock = 0
rocks = 0
current = 0
verbose = false
# grid[0] = [false, false, true, true, true, false, false ]
# grid[1] = [true, true, true, true, false, false, false ]
# grid[2] = [true, true, true, true, true, true, true]
# grid[3] = [true, true, true, true, false, false, false ]
# grid[4] = [false, false, true, true, true, false, false ]
# grid[5] = [false, false, false, true, true, true, true ]
# grid[6] = [false, false, true, true, true, false, true ]
# grid[7] = [false, false, true, true, true, false, true ]
# grid[8] = [false, false, false, false, true, false, false ]
# grid[9] = [false, false, false, false, true, false, false ]



while rocks < 1000000000000 # (15390 * 3) # 15290 * n in rocks =  23823 * n + 5 in height
  
  #
  #  n = 64977257
  #  15290 * 64977257 = 999999985230
  
  #30520659020
             #1514285714288
  next_rock = rock_types[rocks % 5]
  puts puts "Top: #{top_rock}, Rocks: #{rocks}, Next: #{next_rock}, Current: #{current}"


# 23828
# 47651
# 71474
# 95297

  # 64977257  cycles

  # 14760  rocks needed additional

  # 1547953193511  height at 999999985240 rocks



#   Top: 379, Rocks: 10308, Next: I, Current: 10015, Total height: 15764
# Top: 379, Rocks: 10309, Next: o, Current: 10048, Total height: 15764
# Top: 379, Rocks: 10310, Next: -, Current: 10057, Total height: 15764

# 15400
# 30790
# 46180
# 61570


#  23840
#  47663
#  71486
#  95309
# 119132
# 142955
# 166778

  # puts "Top: #{top_rock}, Rocks: #{rocks}, Next: #{next_rock}, Current: #{current}, Total height: #{total_height}" if next_rock == "-" #if top_rock == 0 #&& rocks % 100000 == 0
  rock_bottom = top_rock + 3

  rock_left = 2

  width = @rock_width[next_rock.to_sym]

  if can_move grid, next_rock, rock_left, rock_bottom, lines[current]
    if lines[current] == ">"
      rock_left += 1
    else
      rock_left -= 1
    end
  end
  
  current += 1
  current = current % lines.length

  while can_drop(grid, next_rock, rock_left, rock_bottom)
    rock_bottom -= 1
      
    if can_move grid, next_rock, rock_left, rock_bottom, lines[current]
      if lines[current] == ">"
        rock_left += 1
      else
        rock_left -= 1
      end
    end

    current += 1
    current = current % lines.length
  end

  grid = draw_rock grid, next_rock, rock_left, rock_bottom

  add_to_height = 0

  while grid[top_rock] != [false,false,false,false,false,false,false]
    top_rock += 1
  end

  if top_rock > grid.length - 500
    top_rock.downto(0) do |row|
      if grid[row] == [true,true,true,true,true,true,true]
        # puts "Emptying row: #{top_rock + total_height}"
        grid = reset_bottom grid, row
        add_to_height = row + 1
        break
      end
    end
    
    top_rock = 0
    
    while grid[top_rock] != [false,false,false,false,false,false,false]
      top_rock += 1
    end
    
  end

  # total_height += add_to_height

  # print_grid grid[(top_rock-10)..top_rock+1]

  rocks += 1
end

puts top_rock  #+ total_height


# 1547953216382
# 1547953216383 too low
# 1547953216384 too low
# 1547953216385 too low
# 1547953216386 too low
# 1547953216387 too low
# 1547953216388 too low
# 1547953216389 too low
# 1547953216390 too low
# 1547953216391 too low
# 1547953216392 too low
# 1547953216393 OMFG

# 1547953217334 another cycle up ...  also wrong
# 1547953217339 wrong

# 1547953316383 too high

#        100000

# 1547953236384 wrong