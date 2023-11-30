input = File.read("input")
grid = input.split("\n").map { |row| row.chars.map(&:to_i) }

# Define a helper function that counts the number of visible trees in a row or column
def count_visible_trees(trees)
  # Find the tallest tree in the row or column
  tallest_tree = trees.max

  # Count the number of occurrences of the tallest tree in the row or column
  tallest_tree_count = trees.count(tallest_tree)

  # Return the count of the tallest tree, since it is the only one that is visible
  tallest_tree_count
end

# Initialize a variable to store the total number of visible trees
total_visible_trees = 0

# Iterate over the rows and columns of the grid and add the number of visible trees in each to the total
(0...grid.size).each do |i|
  total_visible_trees += count_visible_trees(grid[i]) # Add the number of visible trees in row i
  total_visible_trees += count_visible_trees(grid.map { |row| row[i] }) # Add the number of visible trees in column i
end

# Print the total number of visible trees
puts total_visible_trees