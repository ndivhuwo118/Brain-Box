class Game < ApplicationRecord
  after_create :set_rounds, unless: :seeding?
  belongs_to :user
  belongs_to :opponent, class_name: 'User'

  has_many :game_players
  has_many :rounds
  has_many :game_categories
  has_many :categories, through: :game_categories

  has_many :users, through: :game_players, as: :players
  has_many :players, through: :game_players, source: :user

  def seeding?
    ENV['SEEDING'] == 'true'
  end

  def set_rounds
    # return if self.rounds.any?

    round_number = 1
    3.times do
      round = Round.new(round_number: round_number, game_id: id)
      round.save!
      puts "#{round.id} round created"

      round_number += 1
    end
  end

  def current_round
    rounds.order(:round_number).last
  end

  def winner!
    # self.game_players
    # if the current user of the game wins, they will be assigned the winner_id
    current_player = game_players.find_by(user_id: user.id)
    opponent_player = game_players.find_by(user_id: opponent.id)
    p current_player

    if current_player.score > opponent_player.score
      update(winner_id: user.id)
      winner = user
    else
      update(winner_id: opponent.id)
      return opponent
      winner = opponent
    end
    # else the opponent will get it
    return User.find(winner.id)
    # Or if the score is the same then the match will be considered a draw
    # Ensure there are players in the game
  end
end
