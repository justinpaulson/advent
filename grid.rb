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

  def initialize y, x, fill="."
    @grid = Array.new(y) { Array.new(x) { fill } }
  end

  def initialize lines
    @grid = Array.new(lines.length) { Array.new(lines[0].length) }
    lines.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        @grid[y][x] = char
      end
    end
  end

  def print joiner:"", highlight_cursor:nil, clear:true, wait:false
    total = @grid.length.to_s.length
    puts `clear` if clear
    0.upto(@grid.length-1) do |y|
      print " " * (total - y.to_s.length) + y.to_s
      print " "
      if highlight_cursor && highlight_cursor[0] == y
        print @grid[y][0..(highlight_cursor[1]-1)].join(joiner) + "," unless highlight_cursor[1] == 0
        print "\e[33m#{@grid[y][highlight_cursor[1]]}\e[0m"
        puts ","+@grid[y][highlight_cursor[1]+1..-1].join(joiner) unless highlight_cursor[1] == @grid[y].length - 1
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
  low = nil
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
  raise "You need to define the goal! How does a point achieve the goal?"
end

def get_neighbors point, path
  raise "You need to define how to get the neighbors of a point! What are the available next nodes?"
end

def score_for_neighbor point, neighbor
  raise "You need to define how to score a neighbor! What is the cost of moving to a new node?"
end

def h point, path
  raise "You need to define the heuristic! How do you estimate the distance to the goal?"
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

def a_star start
  set = [start]
  from = {}

  g = {}
  g[start] = 0

  f = {}
  f[start] = h(start, [start])

  while set.length > 0
    curr_point, lowest = lowest_score f, set

    return [reconstruct_path(from,curr_point), g[curr_point]] if is_goal?(curr_point)

    set -= [curr_point]

    last = from[curr_point]

    neighbors = []

    neighbors = get_neighbors(curr_point, reconstruct_path(from, curr_point))

    neighbors.each do |new_point|
      tent_g = g[curr_point]

      tent_g += score_for_neighbor(curr_point, new_point)

      if !g.keys.include?(new_point) || tent_g < g[new_point]
        from[new_point] = curr_point
        g[new_point] = tent_g
        f[new_point] = tent_g + h(new_point, reconstruct_path(from, new_point))
        set << new_point if !set.include?(new_point)
      end
    end

    print_a_star curr_point, lowest, neighbors, set, from, g, f
  end

  return false
end
