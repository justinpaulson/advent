require '../../grid.rb'
ARGV[0] ||= "input"
lines, moves = IO.read(ARGV[0]).chomp.split("\n\n")
lines = lines.split("\n")
g = Grid.new(lines)

robot = g.find("@")

moves.chars.each do |move|
  case move
  when "^"
    next if g.grid[robot[0]-1][robot[1]] == "#"
    if g.grid[robot[0]-1][robot[1]] == "."
      g.grid[robot[0]][robot[1]] = "."
      g.grid[robot[0]-1][robot[1]] = "@"
      robot[0] -= 1
    else
      shift = [robot[0]-1, robot[1]]
      while g.grid[shift[0]][shift[1]] == "O"
        shift[0] -= 1
      end
      if g.grid[shift[0]][shift[1]] == "."
        g.grid[shift[0]][shift[1]] = "O"
        g.grid[robot[0]][robot[1]] = "."
        g.grid[robot[0]-1][robot[1]] = "@"
        robot[0] -= 1
      end
    end
  when ">"
    next if g.grid[robot[0]][robot[1]+1] == "#"
    if g.grid[robot[0]][robot[1]+1] == "."
      g.grid[robot[0]][robot[1]] = "."
      g.grid[robot[0]][robot[1]+1] = "@"
      robot[1] += 1
    else
      shift = [robot[0], robot[1]+1]
      while g.grid[shift[0]][shift[1]] == "O"
        shift[1] += 1
      end
      if g.grid[shift[0]][shift[1]] == "."
        g.grid[shift[0]][shift[1]] = "O"
        g.grid[robot[0]][robot[1]] = "."
        g.grid[robot[0]][robot[1]+1] = "@"
        robot[1] += 1
      end
    end
  when "v"
    next if g.grid[robot[0]+1][robot[1]] == "#"
    if g.grid[robot[0]+1][robot[1]] == "."
      g.grid[robot[0]][robot[1]] = "."
      g.grid[robot[0]+1][robot[1]] = "@"
      robot[0] += 1
    else
      shift = [robot[0]+1, robot[1]]
      while g.grid[shift[0]][shift[1]] == "O"
        shift[0] += 1
      end
      if g.grid[shift[0]][shift[1]] == "."
        g.grid[shift[0]][shift[1]] = "O"
        g.grid[robot[0]][robot[1]] = "."
        g.grid[robot[0]+1][robot[1]] = "@"
        robot[0] += 1
      end
    end
  when "<"
    next if g.grid[robot[0]][robot[1]-1] == "#"
    if g.grid[robot[0]][robot[1]-1] == "."
      g.grid[robot[0]][robot[1]] = "."
      g.grid[robot[0]][robot[1]-1] = "@"
      robot[1] -= 1
    else
      shift = [robot[0], robot[1]-1]
      while g.grid[shift[0]][shift[1]] == "O"
        shift[1] -= 1
      end
      if g.grid[shift[0]][shift[1]] == "."
        g.grid[shift[0]][shift[1]] = "O"
        g.grid[robot[0]][robot[1]] = "."
        g.grid[robot[0]][robot[1]-1] = "@"
        robot[1] -= 1
      end
    end
  end
end

def score_grid grid
  grid.each_with_index.map do |row, y|
    row.each_with_index.map do |cell, x|
      if cell == "O" || cell == "["
        100 * y + x
      else
        0
      end
    end.sum
  end.sum
end

puts score_grid(g.grid)

g = Grid.new(lines)

big_g = Grid.new(g.grid.length, g.grid[0].length * 2)

g.grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    case cell
    when "@"
      big_g.grid[y][x*2] = "@"
      big_g.grid[y][x*2+1] = "."
    when "O"
      big_g.grid[y][x*2] = "["
      big_g.grid[y][x*2+1] = "]"
    when "#"
      big_g.grid[y][x*2] = "#"
      big_g.grid[y][x*2+1] = "#"
    when "."
      big_g.grid[y][x*2] = "."
      big_g.grid[y][x*2+1] = "."
    end
  end
end

robot = big_g.find("@")

moves.chars.each do |move|
  case move
  when "^"
    next if big_g.grid[robot[0]-1][robot[1]] == "#"
    if big_g.grid[robot[0]-1][robot[1]] == "."
      big_g.grid[robot[0]][robot[1]] = "."
      big_g.grid[robot[0]-1][robot[1]] = "@"
      robot[0] -= 1
    else
      make_move = true
      pieces_to_move = [[robot[0], robot[1]]]
      edges = [[robot[0]-1, robot[1]]]
      while edges.any?
        new_edges = []
        edges.each do |edge|
          if big_g.grid[edge[0]][edge[1]] == "["
            new_edges << [edge[0]-1, edge[1]]
            new_edges << [edge[0]-1, edge[1]+1]
            pieces_to_move << [edge[0], edge[1]]
            pieces_to_move << [edge[0], edge[1]+1]
          elsif big_g.grid[edge[0]][edge[1]] == "]"
            new_edges << [edge[0]-1, edge[1]-1]
            new_edges << [edge[0]-1, edge[1]]
            pieces_to_move << [edge[0], edge[1]]
            pieces_to_move << [edge[0], edge[1]-1]
          elsif big_g.grid[edge[0]][edge[1]] == "#"
            make_move = false
          end
        end
        edges = new_edges
      end

      if make_move
        pieces_to_move.uniq.reverse.each do |piece|
          big_g.grid[piece[0]-1][piece[1]] = big_g.grid[piece[0]][piece[1]]
          big_g.grid[piece[0]][piece[1]] = "."
        end
        robot[0] -= 1
      end
    end
  when ">"
    next if big_g.grid[robot[0]][robot[1]+1] == "#"
    if big_g.grid[robot[0]][robot[1]+1] == "."
      big_g.grid[robot[0]][robot[1]] = "."
      big_g.grid[robot[0]][robot[1]+1] = "@"
      robot[1] += 1
    else
      shift = [robot[0], robot[1]+1]
      while big_g.grid[shift[0]][shift[1]] == "[" || big_g.grid[shift[0]][shift[1]] == "]"
        shift[1] += 1
      end
      if big_g.grid[shift[0]][shift[1]] == "."
        big_g.grid[robot[0]][robot[1]+1..shift[1]] = big_g.grid[robot[0]][robot[1]..shift[1]-1]
        big_g.grid[robot[0]][robot[1]+1] = "@"
        big_g.grid[robot[0]][robot[1]] = "."
        robot[1] += 1
      end
    end
  when "v"
    next if big_g.grid[robot[0]+1][robot[1]] == "#"
    if big_g.grid[robot[0]+1][robot[1]] == "."
      big_g.grid[robot[0]][robot[1]] = "."
      big_g.grid[robot[0]+1][robot[1]] = "@"
      robot[0] += 1
    else
      make_move = true
      pieces_to_move = [[robot[0], robot[1]]]
      edges = [[robot[0]+1, robot[1]]]
      while edges.any?
        new_edges = []
        edges.each do |edge|
          if big_g.grid[edge[0]][edge[1]] == "["
            new_edges << [edge[0]+1, edge[1]]
            new_edges << [edge[0]+1, edge[1]+1]
            pieces_to_move << [edge[0], edge[1]]
            pieces_to_move << [edge[0], edge[1]+1]
          elsif big_g.grid[edge[0]][edge[1]] == "]"
            new_edges << [edge[0]+1, edge[1]-1]
            new_edges << [edge[0]+1, edge[1]]
            pieces_to_move << [edge[0], edge[1]]
            pieces_to_move << [edge[0], edge[1]-1]
          elsif big_g.grid[edge[0]][edge[1]] == "#"
            make_move = false
          end
        end
        edges = new_edges
      end

      if make_move
        pieces_to_move.uniq.reverse.each do |piece|
          big_g.grid[piece[0]+1][piece[1]] = big_g.grid[piece[0]][piece[1]]
          big_g.grid[piece[0]][piece[1]] = "."
        end
        robot[0] += 1
      end
    end
  when "<"
    next if big_g.grid[robot[0]][robot[1]-1] == "#"
    if big_g.grid[robot[0]][robot[1]-1] == "."
      big_g.grid[robot[0]][robot[1]] = "."
      big_g.grid[robot[0]][robot[1]-1] = "@"
      robot[1] -= 1
    else
      shift = [robot[0], robot[1]-1]
      while big_g.grid[shift[0]][shift[1]] == "[" || big_g.grid[shift[0]][shift[1]] == "]"
        shift[1] -= 1
      end
      if big_g.grid[shift[0]][shift[1]] == "."
        big_g.grid[robot[0]][shift[1]..robot[1]-1] = big_g.grid[robot[0]][shift[1]+1..robot[1]]
        big_g.grid[robot[0]][robot[1]] = "."
        big_g.grid[robot[0]][robot[1]-1] = "@"
        robot[1] -= 1
      end
    end
  end
end

puts score_grid(big_g.grid)
