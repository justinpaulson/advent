require 'io/console'
require 'set'

class Array
  def ave
    return nil if empty? # Handle empty array case
    sum.to_f / size
  end
end

def key_wait
  p "press any key"
  STDIN.getch
end

class Grid
  attr_accessor :grid

  def initialize y, x=nil, fill="."
    if x
      @grid = Array.new(y) { Array.new(x) { fill } }
    else
      @grid = Array.new(y.length) { Array.new(y[0].length) }
      y.each_with_index do |line, y_pos|
        if line.is_a? String
          line.chars.each_with_index do |char, x_pos|
            @grid[y_pos][x_pos] = char
          end
        else
          line.each_with_index do |val, x_pos|
            @grid[y_pos][x_pos] = val
          end
        end
      end
    end
  end

  def print_grid joiner:"", highlight_cursor:nil, highlight_target:nil, highlight_path:nil, clear:true, wait:false, range:nil
    total = @grid.length.to_s.length
    puts `clear` if clear
    range ||= 0..@grid.length-1
    range.each do |y|
      print " " * (total - y.to_s.length) + y.to_s
      print " "
      if highlight_cursor && highlight_target && highlight_cursor[0] == y && highlight_target[0] == y
        if highlight_cursor[1] < highlight_target[1]
          print @grid[y][0..(highlight_cursor[1]-1)].join(joiner) unless highlight_cursor[1] == 0
          print "\e[32m#{@grid[y][highlight_cursor[1]]}\e[0m"
          print @grid[y][highlight_cursor[1]+1..(highlight_target[1]-1)].join(joiner)
          print "\e[31m#{@grid[y][highlight_target[1]]}\e[0m"
          puts @grid[y][highlight_target[1]+1..-1].join(joiner) unless highlight_target[1] == @grid[y].length - 1
        else
          print @grid[y][0..(highlight_target[1]-1)].join(joiner) unless highlight_target[1] == 0
          print "\e[31m#{@grid[y][highlight_target[1]]}\e[0m"
          print @grid[y][highlight_target[1]+1..(highlight_cursor[1]-1)].join(joiner)
          print "\e[32m#{@grid[y][highlight_cursor[1]]}\e[0m"
          puts @grid[y][highlight_cursor[1]+1..-1].join(joiner) unless highlight_cursor[1] == @grid[y].length - 1
        end
      elsif highlight_cursor && highlight_cursor[0] == y
        print @grid[y][0..(highlight_cursor[1]-1)].join(joiner) unless highlight_cursor[1] == 0
        print "\e[32m#{@grid[y][highlight_cursor[1]]}\e[0m"
        puts @grid[y][highlight_cursor[1]+1..-1].join(joiner) unless highlight_cursor[1] == @grid[y].length - 1
      elsif highlight_target && highlight_target[0] == y
        print @grid[y][0..(highlight_target[1]-1)].join(joiner) unless highlight_target[1] == 0
        print "\e[31m#{@grid[y][highlight_target[1]]}\e[0m"
        puts @grid[y][highlight_target[1]+1..-1].join(joiner) unless highlight_target[1] == @grid[y].length - 1
      else
        puts @grid[y].join(joiner)
      end
    end
    key_wait if wait
  end

  def rotate direction="cw"
    if direction == "cw"
      @grid.transpose.map(&:reverse)
    elsif direction == "ccw"
      @grid.transpose.reverse
    end
  end

  def rotate! direction="cw"
    @grid = rotate direction
  end

  def flip direction="h"
    if direction == "h"
      @grid.map(&:reverse)
    elsif direction == "v"
      @grid.reverse
    end
  end

  def flip! direction="h"
    @grid = flip direction
  end

  def find val
    grid.each_with_index do |line, y|
      line.each_with_index do |char, x|
        if char == val
          return [y,x]
        end
      end
    end
    nil
  end

  def find_all val
    points = []
    grid.each_with_index do |line, y|
      line.each_with_index do |char, x|
        if char == val
          points << [y,x]
        end
      end
    end
    points
  end

  def find_adjacent point, val
    points = []
    y,x = point
    [[y+1,x],[y-1,x],[y,x+1],[y,x-1]].each do |new_point|
      y,x = new_point
      if y >= 0 && y < @grid.length && x >= 0 && x < @grid[0].length
        points << new_point if @grid[y][x] == val
      end
    end
    points
  end

  def find_all_eight_adjacent point, val
    points = []
    y,x = point
    [[y+1,x],[y-1,x],[y,x+1],[y,x-1],[y+1,x+1],[y+1,x-1],[y-1,x+1],[y-1,x-1]].each do |new_point|
      y,x = new_point
      if y >= 0 && y < @grid.length && x >= 0 && x < @grid[0].length
        points << new_point if @grid[y][x] == val
      end
    end
    points
  end

  def count val
    count = 0
    @grid.each do |line|
      count += line.count(val)
    end
    count
  end

  def key_wait
    p "press any key"
    STDIN.getch
  end
end

def deep_copy(o)
  Marshal.load(Marshal.dump(o))
end

# these should have all the available points for the next move
# along with a hash of all available scores for each point in scores
def lowest_score scores, points
  lowest_score = 9999999
  low = [points[0],scores[points[0]]]
  points.each do |point|
    if scores[point] < lowest_score
      low = [point,scores[point]]
      lowest_score = scores[point]
    end
  end
  low
end

# from is a hash containing all the points as keys and where they came from as values
def reconstruct_path from, current
  total_path = [current]
  while from.keys.include?(current)
    current = from[current]
    total_path.prepend(current)
  end
  total_path
end

def is_goal? point
  raise "You need to define the goal! How does a point achieve the goal?\n\n   def is_goal? point\n\n"
end

def get_neighbors point, path
  raise "You need to define how to get the neighbors of a point! What are the available next nodes?\n\n    def get_neighbors point, path\n\n"
end

def get_neighbors point
  raise "You need to define how to get the neighbors of a point! What are the available next nodes?\n\n    def get_neighbors point, path\n\n"
end

@warned_score_for_neighbor = false
def score_for_neighbor point, neighbor
  if !@warned_score_for_neighbor
    warn "WARNING: You did not define how to score a neighbor! Using a default of 1.\n\n    def score_for_neighbor point, neighbor\n\n"
    @warned_score_for_neighbor = true
  end
  1
end

@warned_h = false
def h point, path
  if !@warned_h
    warn "WARNING: You did not define a heuristic! Using a default of 1.\n\n    def h point, path\n\n"
    @warned_h = true
  end
  1
end

def h point
  if !@warned_h
    warn "WARNING: You did not define a heuristic! Using a default of 1.\n\n    def h point\n\n"
    @warned_h = true
  end
  1
end

def print_a_star curr_point, lowest, neighbors, set, from, g, f
  return
  raise "You need to define how to print the results! What do you want to see at each step?"
end

def has_path? start, target
  set = [start]
  from = {}

  while set.length > 0
    curr_point = set.shift

    return true if curr_point == target

    set -= [curr_point]
    last = from[curr_point]

    neighbors = []

    neighbors = get_neighbors(curr_point, reconstruct_path(from, curr_point))

    neighbors.each do |new_point|
      set << new_point if !set.include?(new_point)
    end
  end

  return false
end

def a_star start, h_path: true, neighbors_path: true
  set = [start]
  from = {}

  g = {}
  g[start] = 0

  f = {}
  if h_path
    f[start] = h(start, [start])
  else
    f[start] = h(start)
  end

  while set.length > 0
    curr_point, lowest = lowest_score f, set
    return [reconstruct_path(from,curr_point), g[curr_point]] if is_goal?(curr_point)
    set -= [curr_point]

    last = from[curr_point]

    neighbors = []
    if neighbors_path
      neighbors = get_neighbors(curr_point, reconstruct_path(from, curr_point))
    else
      neighbors = get_neighbors(curr_point)
    end
    neighbors.each do |new_point|
      tent_g = g[curr_point]
      tent_g += score_for_neighbor(curr_point, new_point)

      if !g[new_point] || tent_g < g[new_point]
        from[new_point] = curr_point
        g[new_point] = tent_g
        if h_path
          f[new_point] = tent_g + h(new_point, reconstruct_path(from, new_point))
        else
          f[new_point] = tent_g + h(new_point)
        end
        set << new_point if !set.include?(new_point)
      end
    end

    print_a_star curr_point, lowest, neighbors, set, from, g, f
  end

  return false
end
