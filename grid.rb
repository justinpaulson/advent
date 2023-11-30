require 'io/console'

def print_grid grid, joiner="", clear=true
  puts `clear` if clear
  0.upto(grid.length-1) do |y|
    print y.to_s
    print " "
    puts grid[y].join(joiner)
  end
  # sleep 0.25 
end

def key_wait                                                                                                               
  p "press any key"                                                                                                    
  STDIN.getch
end 

def new_grid y, x, fill="."
  Array.new(y) { Array.new(x) { fill } }
end