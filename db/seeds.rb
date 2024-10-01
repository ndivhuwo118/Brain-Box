# db/seeds.rb

# Clear existing data to ensure a fresh start
puts "Clearing existing data..."
User.destroy_all
Category.destroy_all
Game.destroy_all
Round.destroy_all
Question.destroy_all
Answer.destroy_all
GamePlayer.destroy_all
GameCategory.destroy_all
PlayersAnswer.destroy_all

# Create sample users
puts "Creating users..."
user_emails = [
  "david@gmail.com",
  "darian@gmail.com",
  "ndi@gmail.com"
]

user_emails.each do |email|
  User.create!(email: email, password: "password123")
end

# Create sample categories
puts "Creating categories..."
categories = ["Science", "History", "Geography", "Entertainment", "Sports"]
categories.each do |name|
  Category.create!(name: name)
end

# Create sample games
puts "Creating games..."
5.times do
  Game.create!(
    user: User.all.sample, # Randomly assign a user to each game
    winner_id: User.all.sample.id # Randomly assign a winner
  )
end

# Create rounds for each game
puts "Creating rounds..."
Game.all.each do |game|
  3.times do |i|
    Round.create!(game: game, round_number: i + 1)
  end
end

# Create questions and answers
puts "Creating questions and answers..."
questions_and_answers = {
  "Science" => [
    {
      question: "What is the chemical symbol for water?",
      answers: ["H2O", "O2", "CO2", "H2"]
    },
    {
      question: "What planet is known as the Red Planet?",
      answers: ["Earth", "Mars", "Jupiter", "Saturn"]
    }
  ],
  "History" => [
    {
      question: "Who was the first president of the United States?",
      answers: ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"]
    },
    {
      question: "In what year did the Titanic sink?",
      answers: ["1912", "1905", "1898", "1920"]
    }
  ],
  "Geography" => [
    {
      question: "What is the capital of France?",
      answers: ["Paris", "London", "Berlin", "Madrid"]
    },
    {
      question: "Which river is the longest in the world?",
      answers: ["Amazon", "Nile", "Yangtze", "Mississippi"]
    }
  ],
  "Entertainment" => [
    {
      question: "Who directed 'Jurassic Park'?",
      answers: ["Steven Spielberg", "James Cameron", "George Lucas", "Peter Jackson"]
    },
    {
      question: "What is the highest-grossing film of all time?",
      answers: ["Avatar", "Titanic", "Star Wars", "The Avengers"]
    }
  ],
  "Sports" => [
    {
      question: "In which sport is the term 'home run' used?",
      answers: ["Baseball", "Football", "Basketball", "Soccer"]
    },
    {
      question: "How many players are there on a soccer team?",
      answers: ["11", "7", "9", "5"]
    }
  ]
}

# Create questions and answers for each category and round
categories.each do |category_name|
  category = Category.find_by(name: category_name)
  questions_and_answers[category_name].each do |item|
    round = Round.all.sample # Randomly assign a round
    question = Question.create!(
      content: item[:question],
      round: round
    )

    item[:answers].each_with_index do |answer_content, index|
      Answer.create!(
        content: answer_content,
        decoy: index > 0, # First answer is correct, others are decoys
        question: question
      )
    end
  end
end

# Create associations between games and categories
puts "Creating game categories..."
Game.all.each do |game|
  Category.all.sample(2).each do |category|
    GameCategory.create!(
      game: game,
      category: category
    )
  end
end

# Create game players for each game
puts "Creating game players..."
Game.all.each do |game|
  User.all.sample(2).each do |user|
    GamePlayer.create!(
      game: game,
      user: user,
      score: rand(0..100) # Assign a random score
    )
  end
end

# Create player answers based on their game participation
puts "Creating player answers..."
GamePlayer.all.each do |game_player|
  Round.all.sample(1).each do |round|
    Question.where(round: round).each do |question|
      Answer.where(question: question).sample(1).each do |answer|
        PlayersAnswer.create!(
          answer: answer,
          user: game_player.user,
          correct: !answer.decoy, # Check if the answer is correct
          round_id: round.id
        )
      end
    end
  end
end

puts "Seeding completed!"
