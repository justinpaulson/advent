# A Hash that maps each shape to its corresponding score
SHAPE_SCORES = {
  "A" => 1, # Rock
  "B" => 2, # Paper
  "C" => 3  # Scissors
}

# A Hash that maps each outcome to its corresponding score
OUTCOME_SCORES = {
  "win"  => 6,
  "loss" => 0,
  "draw" => 3
}

# Calculate the total score for a given strategy guide
def total_score(strategy_guide)
  # Initialize the total score to 0
  total_score = 0

  # Split the strategy guide into lines
  lines = strategy_guide.split("\n")

  # Iterate over the lines in the strategy guide
  lines.each do |line|
    # Split the line into the opponent's shape and your shape
    opponent_shape, your_shape = line.split

    # Look up the scores for each shape using the SHAPE_SCORES Hash
    opponent_score = SHAPE_SCORES[opponent_shape]
    your_score = SHAPE_SCORES[your_shape]

    # Determine the outcome of the round based on the shapes
    puts "Oppenent score: " + opponent_score.to_s
    puts "Your score: " + your_score.to_s
    outcome =
      if opponent_score == your_score
        "draw"
      elsif (opponent_score - your_score) % 3 == 1
        "win"
      else
        "loss"
      end

    # Look up the score for the outcome using the OUTCOME_SCORES Hash
    outcome_score = OUTCOME_SCORES[outcome]

    # Add the score for the round to the total score
    total_score += your_score + outcome_score
  end

  # Return the total score
  total_score
end

p total_score(IO.read("input"))