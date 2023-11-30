# Define a Hash that maps each possible move to its score
moves = {
  'A' => 1, # Rock
  'B' => 2, # Paper
  'C' => 3, # Scissors
  'X' => 1, # Rock
  'Y' => 2, # Paper
  'Z' => 3, # Scissors
}

# Define the strategy guide as an array of strings
strategy_guide = [
  'A Y',
  'B X',
  'C Z',
]

# Initialize the total score to 0
total_score = 0

# strategy_guide = IO.readlines('input')

# Iterate over the strategy guide
strategy_guide.each do |strategy|
  # Split the strategy string into opponent's move and your move
  opponent_move, your_move = strategy.split

  # Calculate the score for the round using the moves Hash
  score = moves[your_move] + moves[opponent_move]

  # If the opponent's move is weaker than your move, add an additional 6 points to the score
  score += 6 if moves[opponent_move] < moves[your_move]

  # Add the score for the round to the total score
  total_score += score
end

# Print the total score
puts total_score