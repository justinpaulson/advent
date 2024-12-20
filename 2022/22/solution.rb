lines = IO.readlines("input").map(&:chomp)

require "../../grid"

grid = new_grid lines.length, lines[0].length

lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    grid[y][x] = char
  end
end

# def wait_for_output grid, current, value, direction
  # print_grid grid
  # puts "#{current} #{value} #{direction}"
  # key_wait
#   true
# end
class  Move
  def self.move grid, current, direction, value
    old_current = current
    waited = false
    while value > 0
      value -= 1
      old_direction = direction
      check = []
      case direction
      when "<"
        check = [current[0], current[1] - 1]
      when "v"
        check = [current[0] + 1, current[1]]
      when "^"
        check = [current[0] - 1, current[1]]
      when ">"
        check = [current[0], current[1] + 1]
      end

      y = check[0]
      x = check[1]

      # puts check.to_s
      
      if direction == "^"  #confirmed
        if x > 99 && y == -1
          # waited = wait_for_output grid, current, value, direction
          check = [199, x-100]
        elsif x > 49 && y == -1
          # waited = wait_for_output grid, current, value, direction
          check = [x+100, 0]
          old_direction = direction
          direction = ">"
        elsif x < 50 && y == 99
          # waited = wait_for_output grid, current, value, direction
          check = [50+x, 50]
          old_direction = direction
          direction = ">"
        end
      elsif direction == "<"  # confirmed
        if y < 50 && x == 49 
          # waited = wait_for_output grid, current, value, direction
          check = [149-y, 0]
          old_direction = direction
          direction = ">"
        elsif y < 100 && x == 49
          # waited = wait_for_output grid, current, value, direction
          check = [100, y-50]
          old_direction = direction
          direction = "v"
        elsif y < 150 && x == -1
          # waited = wait_for_output grid, current, value, direction
          check = [149-y, 50]
          old_direction = direction
          direction = ">"
        elsif y >= 150 && x == -1
          # waited = wait_for_output grid, current, value, direction
          check = [0, y-100]
          old_direction = direction
          direction = "v"
        end
      elsif direction == "v" #confirmed
        if x > 99 && y == 50 
          puts "wer are here", x, y
          # waited = wait_for_output grid, current, value, direction
          check = [x-50, 99]
          old_direction = direction
          direction = "<"
        elsif x > 49 && check[1] <= 99 && y == 150
          # waited = wait_for_output grid, current, value, direction
          check = [100+x, 49]
          old_direction = direction
          direction = "<"
        elsif y == 200
          # waited = wait_for_output grid, current, value, direction
          check = [0, 100+x]
        end
      elsif direction == ">" #confirmed... !?
        if y < 50 && x == 150
          # waited = wait_for_output grid, current, value, direction
          check = [149-y, 99]
          old_direction = direction
          direction = "<"
        elsif y < 100 && y >= 50 && x == 100
          # waited = wait_for_output grid, current, value, direction
          check = [49, y+50]
          old_direction = direction
          direction = "^"
        elsif y < 150 && y >= 100 && x == 100
          # waited = wait_for_output grid, current, value, direction
          check = [149-y, 149]
          old_direction = direction
          direction = "<"
        elsif y >= 150 && x == 50
          # waited = wait_for_output grid, current, value, direction
          check = [149, y-100]
          old_direction = direction
          direction = "^"
        end
      end

      if grid[check[0]][check[1]] == "#"
        value = 0
        direction = old_direction
      end
      if grid[check[0]][check[1]] == "."
        current = [check[0], check[1]]
      end
    end
    # puts "#{current} #{value}"
    # grid[old_current[0]][old_current[1]] = "."
    # grid[current[0]][current[1]] = "\e[41m" + direction + "\e[0m"
    # if waited
      # wait_for_output grid, current, value, direction
    # end
    [current, direction]
  end
end

# start_x = grid[0].find_index(".")

current = [0, 50]

direction = ">"

moves = [10,"R",47,"R",7,"L",35,"L",4,"R",34,"R",29,"L",20,"L",45,"L",43,"R",33,"L",46,"R",31,"R",10,"L",1,"L",6,"R",7,"R",25,"R",45,"L",46,"R",12,"R",35,"L",9,"L",22,"R",10,"L",3,"L",35,"R",48,"R",19,"R",26,"L",6,"L",45,"R",49,"R",5,"L",14,"R",17,"L",4,"L",27,"L",13,"R",24,"L",41,"L",11,"L",15,"L",10,"R",9,"L",9,"L",10,"L",44,"R",8,"L",14,"R",25,"R",32,"L",33,"L",45,"L",25,"R",8,"R",22,"R",44,"L",5,"R",5,"R",23,"R",26,"R",32,"R",36,"L",13,"R",38,"R",27,"L",22,"L",10,"L",33,"R",39,"L",21,"R",28,"L",10,"R",5,"L",14,"R",35,"R",9,"R",16,"L",9,"L",46,"L",28,"L",16,"R",32,"R",4,"L",8,"L",41,"R",20,"L",36,"R",47,"L",31,"R",26,"R",49,"L",4,"L",16,"R",6,"R",40,"L",3,"R",19,"L",15,"R",7,"L",50,"L",40,"L",32,"R",12,"R",2,"R",5,"R",15,"L",10,"L",4,"L",23,"R",9,"L",1,"R",1,"R",48,"R",7,"R",39,"R",32,"R",6,"R",23,"R",38,"L",7,"L",17,"R",28,"R",50,"L",33,"L",27,"R",36,"L",46,"L",44,"R",27,"L",20,"L",2,"L",17,"R",4,"L",21,"L",3,"L",31,"L",29,"L",43,"R",18,"R",14,"R",22,"R",17,"R",7,"R",33,"L",33,"R",30,"R",35,"R",5,"R",35,"R",7,"L",39,"L",30,"L",5,"R",38,"R",6,"L",47,"L",44,"R",33,"R",4,"R",10,"R",17,"R",27,"R",20,"R",44,"R",25,"R",10,"R",26,"R",28,"L",35,"L",28,"L",46,"L",13,"L",11,"L",40,"R",40,"L",8,"R",35,"L",6,"R",27,"R",35,"R",17,"L",10,"R",38,"R",44,"L",23,"R",17,"R",10,"R",38,"R",34,"R",49,"R",46,"L",15,"L",7,"R",26,"L",20,"L",9,"L",14,"L",8,"R",1,"R",41,"R",31,"R",20,"R",27,"R",36,"L",39,"L",48,"R",23,"R",19,"R",44,"L",6,"R",50,"R",49,"R",29,"L",48,"L",4,"L",34,"L",36,"L",43,"R",9,"L",10,"R",4,"L",24,"R",16,"L",25,"R",47,"L",41,"L",10,"R",22,"L",24,"R",3,"L",21,"R",15,"R",36,"L",38,"R",39,"L",37,"L",7,"R",24,"L",39,"L",5,"R",20,"L",9,"L",22,"R",17,"R",18,"R",18,"L",21,"L",32,"R",22,"R",13,"L",15,"L",49,"R",50,"L",31,"L",43,"R",5,"R",17,"L",37,"R",40,"R",41,"L",30,"R",15,"L",9,"R",43,"R",3,"R",23,"L",17,"R",14,"R",29,"L",13,"R",12,"R",5,"L",43,"R",17,"R",34,"L",20,"R",41,"R",4,"L",41,"R",19,"L",45,"L",5,"R",19,"L",2,"R",37,"R",44,"R",25,"R",22,"L",40,"L",31,"R",42,"L",7,"R",36,"R",10,"R",26,"R",26,"R",8,"L",5,"L",30,"R",49,"L",14,"L",48,"R",39,"R",20,"R",32,"R",20,"L",1,"R",47,"L",22,"L",1,"L",3,"L",47,"L",5,"L",47,"R",27,"R",20,"L",26,"R",11,"R",28,"L",18,"L",50,"L",18,"R",46,"L",44,"R",28,"L",33,"R",46,"L",45,"L",1,"L",35,"L",20,"R",5,"R",47,"R",26,"L",3,"L",42,"R",21,"R",30,"L",36,"R",44,"L",19,"L",49,"R",12,"L",13,"R",42,"L",9,"R",6,"R",18,"L",18,"R",43,"L",39,"R",40,"L",29,"R",17,"R",2,"L",14,"R",4,"R",45,"L",44,"L",1,"L",17,"R",27,"L",4,"L",37,"L",1,"R",8,"R",28,"R",36,"L",50,"R",31,"R",21,"L",33,"R",2,"L",33,"R",35,"L",3,"R",4,"R",50,"R",37,"R",38,"L",19,"L",12,"R",40,"L",39,"L",2,"L",14,"R",12,"L",40,"L",4,"L",29,"L",42,"L",5,"R",1,"R",11,"L",33,"R",20,"R",41,"L",21,"R",12,"R",50,"L",19,"L",32,"L",3,"L",35,"R",45,"L",37,"L",4,"L",47,"L",32,"R",28,"L",35,"R",33,"R",2,"L",18,"L",43,"R",23,"R",46,"R",33,"R",29,"R",41,"R",15,"R",3,"L",23,"R",47,"L",48,"R",3,"L",22,"L",36,"L",9,"L",29,"R",17,"L",22,"R",2,"L",40,"R",47,"L",16,"R",35,"R",22,"R",37,"L",35,"R",48,"L",24,"L",36,"L",12,"R",45,"L",9,"L",34,"L",30,"L",16,"R",12,"L",22,"L",28,"R",25,"R",4,"L",8,"L",12,"L",48,"L",37,"L",35,"R",19,"L",7,"L",14,"L",18,"R",9,"R",28,"R",45,"L",50,"R",32,"R",33,"R",8,"L",13,"L",49,"R",16,"R",31,"R",36,"L",41,"R",27,"L",26,"R",33,"L",9,"R",24,"L",40,"L",39,"R",11,"L",3,"L",24,"L",37,"L",23,"R",5,"L",50,"R",39,"R",23,"L",1,"R",22,"L",22,"L",25,"L",19,"R",11,"L",24,"L",5,"L",9,"L",23,"R",21,"L",48,"R",9,"R",1,"R",49,"R",15,"R",32,"R",46,"L",13,"R",14,"L",39,"R",10,"R",1,"R",23,"R",30,"R",15,"L",21,"L",31,"R",7,"L",48,"R",16,"L",43,"L",36,"L",18,"R",42,"L",45,"R",44,"L",40,"R",37,"L",38,"R",33,"L",11,"R",12,"L",30,"R",39,"L",5,"R",31,"R",39,"R",
  20,"L",1,"L",38,"R",16,"L",46,"R",36,"R",48,"R",4,"R",1,"L",6,"R",6,"L",34,"L",16,"L",13,"R",39,"R",3,"R",12,"R",5,"R",38,"R",12,"L",34,"L",39,"R",12,"L",18,"L",25,"L",5,"L",18,"L",45,"R",6,"L",10,"L",7,"R",20,"R",15,"L",49,"R",3,"L",17,"L",20,"L",28,"R",43,"L",48,"R",32,"R",30,"R",44,"L",41,"L",16,"R",41,"L",9,"R",8,"L",21,"L",7,"R",20,"L",22,"R",12,"L",3,"L",49,"R",9,"L",30,"R",13,"L",34,"R",25,"R",46,"R",12,"L",16,"R",23,"R",43,"R",16,"R",49,"R",37,"L",5,"R",29,"R",4,"L",7,"R",40,"R",18,"L",32,"R",16,"L",30,"R",30,"L",7,"R",50,"L",2,"R",13,"R",12,"L",4,"L",34,"L",15,"R",3,"R",22,"R",44,"L",12,"R",7,"R",26,"L",8,"L",38,"R",23,"L",41,"L",45,"R",42,"L",28,"R",7,"R",16,"R",21,"R",32,"R",20,"L",21,"L",49,"R",7,"L",21,"R",38,"R",37,"R",7,"L",42,"R",4,"L",32,"L",31,"L",29,"R",39,"R",47,"L",22,"L",44,"L",2,"L",12,"L",46,"R",31,"R",29,"L",5,"L",32,"R",24,"R",46,"L",48,"R",43,"R",25,"L",45,"R",40,"R",12,"L",41,"L",5,"R",19,"R",16,"R",29,"R",22,"L",47,"R",5,"R",45,"L",10,"R",14,"L",25,"L",19,"R",15,"L",40,"R",4,"L",21,"L",41,"R",27,"L",37,"R",19,"L",34,"R",47,"R",22,"L",22,"L",36,"L",8,"L",38,"R",29,"L",37,"L",47,"L",22,"L",40,"R",12,"L",16,"R",30,"R",44,"L",10,"L",50,"R",49,"R",26,"R",30,"R",31,"R",27,"L",22,"L",33,"R",27,"R",14,"R",22,"L",12,"R",7,"L",25,"L",44,"L",34,"L",46,"L",42,"L",44,"R",20,"L",41,"L",12,"R",30,"L",20,"R",26,"L",8,"L",9,"L",31,"L",15,"R",41,"R",41,"R",43,"L",34,"L",1,"L",14,"L",1,"L",21,"L",17,"R",7,"R",29,"L",37,"R",12,"R",44,"L",10,"R",39,"R",7,"R",25,"L",4,"R",37,"R",16,"R",23,"L",19,"R",7,"L",37,"L",2,"L",5,"R",27,"R",16,"L",33,"R",50,"R",30,"R",2,"L",11,"R",47,"L",44,"R",40,"R",30,"R",48,"L",46,"R",3,"R",9,"L",15,"L",1,"L",41,"R",45,"R",18,"R",5,"R",36,"R",2,"L",7,"L",14,"R",11,"L",50,"L",48,"R",22,"R",40,"L",44,"L",43,"R",39,"R",40,"L",30,"L",9,"L",29,"L",46,"R",23,"R",22,"L",45,"L",45,"R",20,"L",18,"L",8,"R",9,"L",46,"L",38,"L",20,"R",38,"L",35,"L",10,"L",4,"R",41,"R",4,"R",43,"R",9,"R",27,"L",15,"R",42,"R",35,"L",4,"L",49,"L",49,"R",11,"R",36,"R",38,"L",9,"L",15,"R",7,"L",45,"L",43,"R",4,"R",30,"L",5,"L",12,"L",36,"L",28,"R",42,"R",13,"R",50,"L",45,"L",24,"L",19,"L",39,"L",7,"L",24,"L",50,"R",23,"L",30,"R",12,"L",6,"R",12,"L",24,"L",36,"R",35,"R",43,"R",39,"L",31,"L",37,"R",14,"L",5,"L",32,"R",19,"R",34,"R",45,"L",47,"L",40,"R",23,"R",37,"L",22,"R",14,"L",50,"R",39,"L",42,"L",19,"R",11,"L",17,"L",14,"R",29,"L",30,"L",20,"L",11,"R",21,"R",42,"R",28,"L",44,"L",10,"L",41,"L",5,"R",41,"L",48,"L",30,"R",49,"R",25,"R",22,"R",46,"L",41,"L",20,"L",34,"R",41,"R",23,"R",5,"L",21,"L",38,"L",24,"L",16,"R",11,"R",33,"R",8,"L",43,"L",19,"R",36,"L",42,"R",38,"R",15,"L",43,"R",10,"L",41,"L",34,"L",27,"L",1,"R",36,"L",18,"R",12,"R",47,"R",7,"L",23,"L",20,"L",43,"R",47,"L",25,"R",3,"L",24,"R",26,"L",42,"R",9,"R",38,"R",8,"L",35,"R",46,"L",40,"R",3,"R",48,"L",50,"R",25,"R",15,"L",45,"L",45,"R",28,"R",44,"L",43,"R",18,"L",23,"R",22,"L",5,"R",32,"L",31,"L",29,"R",41,"R",33,"L",42,"R",2,"R",32,"L",48,"R",32,"L",4,"R",41,"R",25,"R",12,"R",20,"L",34,"L",12,"R",24,"R",2,"L",30,"L",26,"R",21,"R",19,"R",43,"R",22,"L",11,"R",1,"L",36,"R",17,"R",11,"R",1,"L",17,"R",25,"L",42,"R",49,"R",7,"L",50,"L",43,"R",20,"R",16,"R",36,"R",7,"L",37,"L",23,"L",6,"R",5,"R",7,"R",30,"L",4,"L",20,"L",44,"L",43,"R",8,"R",16,"L",1,"R",24,"R",44,"R",32,"L",35,"L",17,"R",12,"L",41,"L",40,"L",6,"R",44,"L",30,"L",22,"R",39,"L",35,"L",28,"L",25,"R",38,"R",2,"L",4,"L",2,"L",44,"R",36,"R",47,"R",9,"L",26,"R",20,"L",36,"R",41,"L",5,"L",44,"L",46,"R",13,"L",6,"L",41,"L",38,"L",3,"R",8,"L",43,"L",18,"R",8,"R",8,"L",25,"L",19,"L",19,"L",29,"L",12,"L",36,"L",11,"R",42,"R",27,"L",14,"R",17,"R",22,"L",42,"L",34,"L",35,"R",49,"R",5,"R",1,"L",26,"R",18,"R",7,"L",34,"L",8,"R",
  42,"L",29,"R",2,"L",15,"R",17,"R",29,"R",39,"L",22,"R",12,"L",17,"L",25,"L",45,"L",41,"L",50,"L",45,"L",49,"L",42,"R",21,"R",16,"L",17,"L",16,"R",20,"L",6,"R",21,"L",26,"R",33,"L",42,"R",35,"L",28,"R",31,"L",30,"L",39,"L",17,"L",47,"L",25,"R",17,"L",29,"R",4,"R",15,"R",3,"R",27,"L",20,"R",49,"L",23,"R",29,"R",2,"L",28,"R",43,"R",21,"R",14,"L",41,"L",45,"L",20,"R",31,"R",16,"L",46,"R",10,"R",8,"R",33,"L",44,"L",38,"R",16,"L",19,"R",30,"R",7,"R",4,"R",13,"L",37,"R",46,"R",23,"R",5,"R",2,"R",23,"L",42,"R",22,"L",1,"R",8,"L",12,"R",15,"L",9,"L",49,"L",13,"R",2,"L",1,"L",11,"L",15,"R",29,"L",3,"R",23,"L",21,"L",40,"L",32,"L",44,"L",32,"R",44,"L",10,"L",44,"L",1,"L",7,"R",38,"R",50,"R",25,"R",14,"L",32,"R",25,"R",15,"L",18,"R",1,"L",40,"R",34,"L",17,"R",9,"L",8,"R",26,"R",29,"R",7,"L",19,"R",6,"L",18,"R",47,"R",11,"L",25,"R",2,"R",37,"L",29,"L",47,"L",32,"L",1,"R",6,"L",44,"L",29,"L",45,"R",25,"L",12,"L",5,"L",13,"L",28,"L",20,"R",30,"R",50,"L",39,"L",9,"R",15,"L",4,"L",30,"L",36,"R",27,"R",34,"R",3,"L",16,"L",41,"R",42,"L",9,"R",16,"R",50,"R",45,"L",14,"L",10,"R",46,"R",28,"L",6,"L",45,"L",44,"L",22,"L",40,"L",32,"L",20,"L",34,"R",18,"L",30,"L",4,"R",14,"R",29,"R",9,"L",15,"R",13,"L",50,"L",3,"R",37,"R",38,"R",42,"R",35,"L",10,"R",31,"R",25,"R",33,"R",6,"R",26,"R",33,"L",6,"R",33,"R",35,"R",4,"L",12,"R",27,"R",18,"L",47,"L",40,"R",17,"L",22,"L",8,"R",17,"R",40,"L",44,"R",23,"L",44,"L",5,"L",37,"L",20,"L",14,"L",16,"R",15,"L",38,"R",34,"R",37,"L",10,"R",29,"R",20,"R",40,"L",40,"L",10,"R",11,"L",5,"R",18,"R",26,"L",17,"R",50,"L",27,"R",40,"L",7,"R",14,"R",28,"L",39,"L",13,"R",3,"L",38,"R",7,"R",26,"L",33,"R",3,"R",36,"L",7,"R",24,"L",9,"L",31,"R",39,"R",38,"L",20,"L",8,"R",42,"R",32,"L",5,"R",7,"L",19,"L",9,"R",18,"R",46,"L",20,"R",26,"R",3,"R",27,"R",45,"L",3,"R",21,"L",36,"R",39,"L",49,"R",16,"L",42,"R",1,"R",48,"R",3,"R",24,"L",50,"L",29,"R",46,"R",32,"L",13,"R",50,"L",50,"L",34,"R",26,"L",7,"R",24,"R",25,"R",27,"L",30,"L",23,"R",32,"L",9,"L",20,"L",50,"R",15,"R",4,"L",21,"R",1,"R",39,"L",50,"R",9,"R",1,"R",25,"L",44,"L",48,"R",16,"L",47,"L",36,"R",21,"L",15,"L",5,"R",1,"L",6,"L",1,"R",45,"L",5,"R",29,"L",29,"L",26,"R",36,"R",47,"L",43,"L",7,"L",48,"L",15,"L",8,"R",5,"L",17,"L",37,"R",17,"R",30,"L",35,"R",40,"R",21,"R",18,"R",9,"L",44,"L",27,"R",14,"R",41,"L",40,"L",25,"L",27,"R",42,"L",33,"R",17,"L",34,"R",29,"R",50,"R",35,"L",16,"R",11,"R",47,"R",36,"L",12,"L",41,"R",2,"L",19,"L",3,"L",17,"L",46,"R",1,"R",39,"R",36,"L",37,"R",19,"R",29,"L",1,"R",37,"R",15,"L",11,"R",41,"L",12,"L",16,"R",4,"R",35,"R",49,"R",20,"L",6,"R",35,"R",38,"L",5,"R",35,"R",3,"R",14,"R",4,"L",47,"R",5,"R",24,"L",40,"L",44,"L",16,"R",32,"L",18,"L",2,"R",21,"R",5,"L",25,"L",18,"R",4,"L",4,"R",5,"R",36,"L",45,"L",8,"R",34,"L",42,"L",24,"L",35,"L",17,"L",45,"R",37,"R",48,"L",32,"R",14,"R",40,"L",21,"L",45,"L",11,"R",14,"R",31,"R",31,"L",20,"R",41,"L",42,"L",21,"R",33,"R",33,"L",49,"L",41,"R",8,"R",25,"R",1,"R",27,"R",3,"L",37,"L",5,"L",24,"L",48,"L",44,"L",10,"L",13,"R",43,"L",18,"L",20,"R",27,"L",47,"R",21,"L",34,"L",29,"R",11,"L",43,"R",6,"L",44,"R",35,"R",38,"L",16,"R",25,"L",13,"R",36,"L",22,"L",41,"R",7,"R",47,"L",24,"L",43,"L",7,"R",37,"R",12,"L",26,"R",23,"R",32,"R",26,"R",43,"L",44,"R",41,"L",34,"R",30,"R",19,"L",30,"L",38,"R",19,"R",34,"L",33,"L",48,"R",38,"R",9,"L",35,"R",40,"L",41,"R",37,"L",37,"L",35,"R",31,"R",50,"R",48,"R",38,"L",33,"L",47,"L",17,"R",13,"L",45,"R",34,"L",40,"L",17,"L",5,"R",47,"R",25,"L",28,"R",19,"L",50,"L",11,"L",11,"R",23,"L",29,"R",20,"L",13,"R",42,"L",50,"L",22,"L",6,"L",21,"L",24,"R",12,"R",34,"R",22,"R",46,"R",33,"L",14,"L",46,"R",18,"L",32,"L",19,"L",19,"L",42,"R",29,"R",23,"L",19,"L",23,"R",25,"L",27,"R",45,"R",3,"L",1,"R",28,"L",
  46,"L",50,"R",17,"R",31,"L",41,"R",41,"R",39,"R",30,"R",19,"R",43,"L",44,"R",35,"L",14,"R",41,"R",23,"L",28,"R",9,"L",13,"L",17,"L",30,"R",15,"L",39,"L",5,"R",10,"L",39,"L",45,"L",31,"R",37,"L",22,"L",3,"L",31,"R",8,"R",9,"R",19,"L",18,"R",20,"L",21,"L",37,"L",24,"L",41,"L",9,"R",45,"L",33,"L",24,"R",47,"R",44,"L",11,"R",25,"R",5,"L",36,"R",43,"L",15,"R",28,"L",5,"R",33,"R",18,"L",34,"R",32,"R",30,"R",2,"L",29,"R",16,"L",37,"R",43,"L",28,"R",41,"R",12,"L",22,"L",26,"R",21,"L",35,"L",29,"L",25,"R",17,"R",7,"R",18,"R",10,"R",15,"R",33,"L",49,"L",9,"R",28,"L",33,"L",4,"L",43,"R",21,"L",5,"L",15,"L",24,"L",3,"L",24,"L",20,"L",33,"R",43,"R",36,"L",23,"R",10,"R",40,"R",4,"R",1,"L",26,"R",29,"R",20,"L",2,"L",50,"L",39,"R",4,"R",40,"L",13,"L",13,"R",43,"R",25,"L",38,"R",7,"R",48,"R",33,"R",12,"L",49,"L",25,"R",7,"L",36,"L",42,"R",21,"L",22,"R",10,"R",30,"L",6,"R",35,"L",11,"L",3,"L",8,"R",50,"L",3,"R",34,"R",13,"L",13,"R",33,"L",6,"L",9,"L",7,"R",25,"R",11,"R",9,"R",14,"R",12,"L",18,"R",28,"L",18,"L",44,"R",21,"L",4,"R",25,"L",18,"L",29,"R",23,"L",21,"R",46,"L",32,"R",44,"R",16,"R",47,"R",40,"L",43,"L",11,"R",44,"R",41,"R",30,"R",42,"R",5,"R",20,"L",12,"L",26,"R",21,"R",17,"L",18,"R",24,"L",30,"R",2,"R",2,"R",26,"L",5,"R",44,"L",19,"R",11,"L",16,"R",35,"L",47,"R",12,"L",32,"L",47,"L",18,"R",28,"L",32,"L",1,"L",1,"L",11,"L",48,"L",50,"L",37,"R",44,"L",12,"R",34,"L",21,"R",8,"R",41,"R",17,"L",43,"R",38,"L",5,"L",17,"R",4,"L",16,"L",33,"L",15,"L",31,"L",23,"R",18,"R",22,"R",39,"L",40,"R",38,"L",10,"R",50,"L",35,"R",18,"R",11,"L",17,"L",6,"L",46,"L",24,"R",25,"R",12,"R",19,"R",12,"R",41,"R",43,"R",16,"R",21,"R",23,"L",2,"R",19,"L",27,"L",5,"L",45,"L",13,"R",47,"R",22,"R",5,"R",2,"R",14,"R",11,"R",34,"R",40,"L",48,"R",45,"R",50,"L",4,"R",16,"L",10,"L",42,"R",37,"L",25,"L",3,"L",44,"L",11,"R",7,"L",16,"R",34,"R",2,"R",28,"L",3,"L",23,"L",26,"R",11,"L",10,"L",27,"R",15,"L",14,"R",39,"R",11,"L",4,"R",26,"L",40,"L",48,"L",12,"R",49,"R",42,"L",43,"L",49,"L",38,"R",33,"R",24,"R",26,"R",12,"R",46,"L",36,"R",19,"L",42,"L",34,"L",50,"L",28,"L",49,"L",46,"L",36,"R",37,"R",18,"L",11,"L",15,"R",47,"L",49,"L",1,"L",48,"R",44,"L",3,"L",26,"L",18,"R",28,"L",44,"L",29,"L",7,"L",7,"R",50,"R",36,"L",50,"L",39,"L",1,"L",11,"L",23,"L",50,"L",14,"R",39,"L",33,"L",8,"L",46,"L",44,"L",29,"R",50,"L",48,"R",9,"L",41,"R",18,"R",17,"L",24,"L",32,"R",20,"R",30,"L",16,"R",25,"L",32,"R",1,"R",10,"R",43,"R",21,"R",3,"L",41,"R",9,"L",38,"L",32,"R",13,"R",42,"L",41,"R",47,"L",12,"R",28,"R",10,"L",30,"L",2,"R",27,"L",1,"L",42,"L",45,"R",14]


# moves = [10,"R",5,"L",5,"R",10,"L",4,"R",5,"L",5]

while moves.length > 0
  next_move = moves.shift
  if next_move.class == Integer
    current, direction = Move.move grid, current, direction, next_move
  elsif next_move == "R"
    case direction
    when "<"
      direction = "^"
    when "v"
      direction = "<"
    when "^"
      direction = ">"
    when ">"
      direction = "v"
    end
  else
    case direction
    when "<"
      direction = "v"
    when "v"
      direction = ">"
    when "^"
      direction = "<"
    when ">"
      direction = "^"
    end
  end
end


dir_num = case direction
when "<"
  2
when "v"
  1
when "^"
  3
when ">"
  0
end

puts (current[0]+1)*1000 + 4*(current[1]+1) + dir_num

# 170044 too low
# 170043 too low
# 142073 too low

# 190053 random guess, wrong