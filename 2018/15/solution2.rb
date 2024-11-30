require '../../grid.rb'
ARGV[0] ||= "input"
ARGV[1] ||= "n"
fast = ARGV[1] == "f"
lines = IO.readlines(ARGV[0]).map(&:chomp)

def is_goal? point
  @goal == point
end

def get_neighbors point, path
  y, x = point
  neighbors = []
  [[y-1, x], [y, x-1], [y, x+1], [y+1, x]].each do |neighbor|
    next if path.include?(neighbor)
    next if @grid[neighbor[0]][neighbor[1]] == "#"
    next if @grid[neighbor[0]][neighbor[1]] == "E" || @grid[neighbor[0]][neighbor[1]] == "G"
    neighbors << neighbor
  end
  neighbors
end

def score_for_neighbor point, neighbor
  1
end

def h point, path
  (@goal[0] - point[0]).abs + (@goal[1] - point[1]).abs
end

def get_goals point
  positions = @grid[point[0]][point[1]] == "E" ? @goblins.keys : @elves.keys
  positions.sort.map do |position|
    y, x = position
    [[y-1, x], [y, x-1], [y, x+1], [y+1, x]].select do |neighbor|
      @grid[neighbor[0]][neighbor[1]] == "."
    end
  end.flatten(1).sort
end

def touching_enemy point
  y, x = point
  this_elf = @grid[y][x]
  enemy = [[y-1, x], [y, x-1], [y, x+1], [y+1, x]].min_by do |neighbor|
    ret = 999999
    if this_elf == "E"
      ret = @goblins[neighbor] if @grid[neighbor[0]][neighbor[1]] == 'G'
    elsif this_elf == "G"
      ret = @elves[neighbor] if @grid[neighbor[0]][neighbor[1]] == 'E'
    end
    ret
  end
  return enemy if this_elf == "E" && @grid[enemy[0]][enemy[1]] == "G"
  return enemy if this_elf == "G" && @grid[enemy[0]][enemy[1]] == "E"
  false
end

def possible_moves point
  y, x = point
  [[y-1, x], [y, x-1], [y, x+1], [y+1, x]].select do |neighbor|
    @grid[neighbor[0]][neighbor[1]] == "."
  end
end

elf_power = 10
while true
  elf_power += 1
  @elves = {}
  @goblins = {}

  @grid = new_grid lines.length, lines[0].length
  lines.each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      @grid[y][x] = char
      if char == "E"
        @elves[[y, x]] = 200
      elsif char == "G"
        @goblins[[y, x]] = 200
      end
    end
  end
  rounds = 0
  failed_test = false
  while @elves.count > 0 && @goblins.count > 0 && !failed_test
    (@elves.keys + @goblins.keys).sort.each do |elf_or_goblin|
      # puts "Elf: #{elf_or_goblin} #{@elves[elf_or_goblin]}" if @elves[elf_or_goblin]
      # puts "Goblin: #{elf_or_goblin} #{@goblins[elf_or_goblin]}" if @goblins[elf_or_goblin]
      elf = elf_or_goblin if @elves[elf_or_goblin]
      goblin = elf_or_goblin if @goblins[elf_or_goblin]
      if elf
        if (goblin = touching_enemy(elf))
          @goblins[goblin] -= elf_power
          if @goblins[goblin] <= 0
            @grid[goblin[0]][goblin[1]] = "."
            @goblins.delete(goblin)
          end
        else
          target = get_goals(elf).min_by do |goal|
            @goal = goal
            result = a_star(elf)
            if result
              result[1]
            else
              999999
            end
          end
          next unless target
          @goal = target

          # puts "Goal is: #{@goal}"
          move = nil
          min_distance = 999999
          possible_moves(elf).each do |m|
            path, distance = a_star(m)
            next unless path

            if distance < min_distance
              move = m
              min_distance = distance
            end
          end
          next unless move

          @grid[elf[0]][elf[1]] = "."
          @grid[move[0]][move[1]] = "E"
          @elves[move] = @elves[elf]
          @elves.delete(elf)

          if (goblin = touching_enemy(move))
            @goblins[goblin] -= elf_power
            if @goblins[goblin] <= 0
              @grid[goblin[0]][goblin[1]] = "."
              @goblins.delete(goblin)
            end
          end
        end
      elsif goblin
        if (elf = touching_enemy(goblin))
          @elves[elf] -= 3
          if @elves[elf] <= 0
            @grid[elf[0]][elf[1]] = "."
            @elves.delete(elf)
            failed_test = true
          end
        else
          target = get_goals(goblin).min_by do |goal|
            @goal = goal
            result = a_star(goblin)
            if result
              result[1]
            else
              999999
            end
          end
          next unless target
          @goal = target
          # puts "Goal is: #{@goal}"
          move = nil
          min_distance = 999999
          possible_moves(goblin).each do |m|
            path, distance = a_star(m)
            next unless path

            if distance < min_distance
              move = m
              min_distance = distance
            end
          end
          next unless move

          @grid[goblin[0]][goblin[1]] = "."
          @grid[move[0]][move[1]] = "G"
          @goblins[move] = @goblins[goblin]
          @goblins.delete(goblin)

          if (elf = touching_enemy(move))
            @elves[elf] -= 3
            if @elves[elf] <= 0
              @grid[elf[0]][elf[1]] = "."
              @elves.delete(elf)
              failed_test = true
            end
          end
        end
      end
    end
    rounds += 1
    # puts "After Round: #{rounds}"
    # print_grid @grid, "", false, false
    # puts "Elves: #{@elves}"
    # puts "Goblins: #{@goblins}"
    # key_wait unless fast
  end

  puts (rounds - 1) * (@elves.values.sum + @goblins.values.sum) unless failed_test
  break unless failed_test
end
