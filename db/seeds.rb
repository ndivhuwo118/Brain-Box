require 'net/http'
require 'json'

# Method to fetch trivia questions from Open Trivia Database
def fetch_trivia_questions(amount, difficulty)
  url = URI("https://opentdb.com/api.php?amount=#{amount}&difficulty=#{difficulty}")
  response = Net::HTTP.get(url)
  JSON.parse(response)["results"]
end

# Clear existing data to ensure a fresh start
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
  "ndi@gmail.com"
]

user_nicknames = [
  "jr",
  "darian",
  "ndivo"
]

user_emails.each_with_index do |email, index|
  User.create!(email: email, password: "password123", nickname: user_nicknames[index])
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
  me = User.all.sample
  opp = User.all.sample
  Game.create!(
    user: User.all.sample,
    winner_id: User.all.sample.id,
    opponent: me == opp ? me : User.all.sample
  )
end

# Create rounds for each game
puts "Creating rounds..."
Game.all.each do |game|
  3.times do |i|
    Round.create!(game: game, round_number: i + 1)
  end
end

# Fetch questions from Open Trivia API
puts "Fetching trivia questions..."
questions_and_answers = fetch_trivia_questions(3, 'medium')

# Create questions and answers using trivia data
puts "Creating questions and answers..."
questions_and_answers.each do |trivia|
  round = Round.all.sample
  question = Question.create!(
    content: trivia["question"],
    round: round
  )

  correct_answer = trivia["correct_answer"]
  incorrect_answers = trivia["incorrect_answers"]

  # Create correct answer
  Answer.create!(
    content: correct_answer,
    decoy: false,
    question: question
  )

  # Create incorrect (decoy) answers
  incorrect_answers.each do |decoy_answer|
    Answer.create!(
      content: decoy_answer,
      decoy: true,
      question: question
    )
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
