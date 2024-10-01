# db/seeds.rb

# Clear existing data
User.destroy_all
Category.destroy_all
Game.destroy_all
Round.destroy_all
Question.destroy_all
Answer.destroy_all
GamePlayer.destroy_all
GameCategory.destroy_all
PlayersAnswer.destroy_all

# Create users
5.times do |i|
  User.create!(
    email: "user#{i}@example.com",
    password: "password123"
  )
end

User.create!(
  email: "david@gmail.com",
  password: "password123"
)

User.create!(
  email: "darian@gmail.com",
  password: "password123"
)

User.create!(
  email: "ndi@gmail.com",
  password: "password123"
)

# Create categories
5.times do |i|
  Category.create!(
    name: "Category #{i + 1}"
  )
end

# Create games
5.times do |i|
  Game.create!(
    user: User.all.sample, # Random user
    winner_id: User.all.sample.id # Random user ID for winner
  )
end


# Create rounds
Game.all.each do |game|
  3.times do |i|
    Round.create!(
      game: game,
      round_number: i + 1
    )
  end
end

# Create questions
Round.all.each do |round|
  3.times do |i|
    Question.create!(
      content: "Question #{i + 1} for Round #{round.round_number}",
      round: round
    )
  end
end

# Create answers
Question.all.each do |question|
  4.times do |i|
    Answer.create!(
      content: "Answer #{i + 1} for Question '#{question.content}'",
      decoy: i > 0, # First answer is correct, others are decoys
      question: question
    )
  end
end

# Create game categories
Game.all.each do |game|
  Category.all.sample(2).each do |category|
    GameCategory.create!(
      game: game,
      category: category
    )
  end
end

# Create game players
Game.all.each do |game|
  User.all.sample(2).each do |user|
    GamePlayer.create!(
      game: game,
      user: user,
      score: rand(0..100) # Random score between 0 and 100
    )
  end
end

# Create player answers
GamePlayer.all.each do |game_player|
  Round.all.sample(1).each do |round|
    Question.where(round: round).each do |question|
      Answer.where(question: question).sample(1).each do |answer|
        PlayersAnswer.create!(
          answer: answer,
          user: game_player.user,
          correct: answer.decoy == false, # Correct if the answer is not a decoy
          round_id: round.id
        )
      end
    end
  end
end

puts "Seeding completed!"
