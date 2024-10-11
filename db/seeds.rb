# Clear existing data to ensure a fresh start
require "open-uri"
ENV['SEEDING'] = 'true'
puts "Clearing existing data..."
GameCategory.destroy_all
Category.destroy_all
Answer.destroy_all
Question.destroy_all
Round.destroy_all
GamePlayer.destroy_all
Game.destroy_all
PlayersAnswer.destroy_all
User.destroy_all

# Create sample users
puts "Creating users..."
user_emails = [
  "david@gmail.com",
  "darian@gmail.com",
  "ndi@gmail.com",
   "kiki@gmail.com",
   "megan@gmail.com",
   "janet@gmail.com",
   "mmanare@gmail.com",
   "ajmal@gmail.com",
   "christain@gmail.com"
  # "prince@gmail.com"

]

user_nicknames = [
  "Davidjunior1991",
  "dariancpt",
  "ndivhuwo118",
   "KIKMAKER",
   "meganjstreet",
    "Jaynettt",
   "mmanare-mahlatse",
   "ajmalonly",
  "cbongard90"
  #  "azaniamzolisa"


]

user_emails.each_with_index do |email, index|
 user =  User.create!(email: email, password: "password123", nickname: user_nicknames[index])
 user_avatar = URI.open("https://kitt.lewagon.com/placeholder/users/#{user.nickname}")
 p "https://kitt.lewagon.com/placeholder/users/#{user.nickname}"
 user.avatar.attach(io: user_avatar, filename: "#{user.nickname}.jpeg", content_type: "image/jpeg")
user.save
end

# Create sample categories
puts "Creating categories..."
categories = ["Science", "History", "Geography", "Entertainment", "Sports"]
categories.each do |name|
  Category.create!(name: name)
end

# Create sample games
puts "Creating games..."
25.times do
  user = User.all.sample
  opponent = User.where.not(id: user.id).sample
  winner = [user, opponent].sample

  Game.create!(
    user: user,
    winner_id: winner.id,
    opponent_id: opponent.id
  )
end

# Verify games are created
puts "Games created: #{Game.count}"  # Output the count of games created

# Create rounds for each game
puts "Creating rounds..."
Game.all.each do |game|
  3.times do |i|
    Round.create!(game: game, round_number: i + 1)
  end
end

# Trivia data for questions and answers
questions_and_answers = {
  "Science" => [
    {
      question: "What is the chemical symbol for water?",
      answers: ["H2O", "O2", "CO2", "H2"],
      correct_answer: "H2O"
    },
    {
      question: "What planet is known as the Red Planet?",
      answers: ["Earth", "Mars", "Jupiter", "Saturn"],
      correct_answer: "Mars"
    }
  ],
  "History" => [
    {
      question: "Who was the first president of the United States?",
      answers: ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"],
      correct_answer: "George Washington"
    },
    {
      question: "In what year did the Titanic sink?",
      answers: ["1912", "1905", "1898", "1920"],
      correct_answer: "1912"
    }
  ],
  "Geography" => [
    {
      question: "What is the capital of France?",
      answers: ["Paris", "London", "Berlin", "Madrid"],
      correct_answer: "Paris"
    },
    {
      question: "Which river is the longest in the world?",
      answers: ["Amazon", "Nile", "Yangtze", "Mississippi"],
      correct_answer: "Nile"
    }
  ],
  "Entertainment" => [
    {
      question: "Who directed 'Jurassic Park'?",
      answers: ["Steven Spielberg", "James Cameron", "George Lucas", "Peter Jackson"],
      correct_answer: "Steven Spielberg"
    },
    {
      question: "What is the highest-grossing film of all time?",
      answers: ["Avatar", "Titanic", "Star Wars", "The Avengers"],
      correct_answer: "Avatar"
    }
  ],
  "Sports" => [
    {
      question: "In which sport is the term 'home run' used?",
      answers: ["Baseball", "Football", "Basketball", "Soccer"],
      correct_answer: "Baseball"
    },
    {
      question: "How many players are there on a soccer team?",
      answers: ["11", "7", "9", "5"],
      correct_answer: "11"
    }
  ]
}

# Create questions and answers for each category and round
# Create questions and answers for each category and round
puts "Creating questions and answers..."
rounds = Round.left_joins(:question).where(questions: { id: nil })
until rounds.empty?

  categories.each do |category_name|
    category = Category.find_by(name: category_name)

    next unless category # Skip if the category does not exist

    questions_and_answers[category_name].each do |item|

      round = rounds.sample # Randomly assign a round that doesn't have a question yet
      next unless round # Skip if there are no rounds

      question = Question.create!(
        content: item[:question],
        round: round
      )

      # Create the correct answer
      Answer.create!(
        content: item[:correct_answer],
        decoy: false, # Correct answer
        question: question
      )

      # Gather incorrect answers
      incorrect_answers = item[:answers].reject { |ans| ans == item[:correct_answer] }

      # Ensure there are enough valid incorrect answers
      next if incorrect_answers.length < 3  # Skip if not enough incorrect answers

      # Randomly select three unique decoys
      selected_decoys = incorrect_answers.sample(3)

      # Create decoy answers
      selected_decoys.each do |decoy_answer|
        # Ensure we're not creating nil content
        next if decoy_answer.nil?

        Answer.create!(
          content: decoy_answer,
          decoy: true, # Incorrect answer
          question: question
        )
      end
    end
  end
  rounds = Round.left_joins(:question).where(questions: { id: nil })
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
  GamePlayer.create!(
    game: game,
    user: game.user,
    score: rand(0..3) ,
    played: [true, false].sample
  )
  GamePlayer.create!(
    game: game,
    user: game.opponent,
    score: rand(0..3),
    played: [true, false].sample
  )
end

# Create player answers based on their game participation
# puts "Creating player answers..."
# GamePlayer.all.each do |game_player|
#   Round.all.sample(1).each do |round|
#     Question.where(round: round).each do |question|
#       Answer.where(question: question).sample(1).each do |answer|
#         PlayersAnswer.create!(
#           answer: answer,
#           user: game_player.user,
#           correct: !answer.decoy, # Check if the answer is correct
#           round_id: round.id
#         )
#       end
#     end
#   end
# end

puts "Seeding complete!"
ENV['SEEDING'] = 'true'
