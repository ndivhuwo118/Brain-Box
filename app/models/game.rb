class Game < ApplicationRecord
  after_create :set_rounds, unless: :seeding?
  belongs_to :user
  belongs_to :opponent, class_name: 'User'

  has_many :game_players
  has_many :rounds
  has_many :game_categories
  has_many :categories, through: :game_categories
  has_many :questions, through: :rounds

  has_many :users, through: :game_players, as: :players
  has_many :players, through: :game_players, source: :user

  has_many :messages, dependent: :destroy
  belongs_to :user

  def seeding?
    ENV['SEEDING'] == 'true'
  end

  def set_rounds
    SetRoundsJob.perform_later(self)
  end

  def current_round
    rounds.order(:round_number).last
  end


  def current_player
    game_players.find_by(user_id: user.id)
  end

  def opponent_player
    game_players.find_by(user_id: opponent.id)
  end

  def complete?
    current_player.played && opponent_player.played
  end

  def winner!
    # self.game_players
    # if the current user of the game wins, they will be assigned the winner_id
    if current_player.score > opponent_player.score
      update(winner_id: user.id)
      winner_user = user
    elsif current_player.score < opponent_player.score
      update(winner_id: opponent_player.user.id)
      winner_user = opponent
    else
      winner_user = nil
    end
    # else the opponent will get it
    # Or if the score is the same then the match will be considered a draw
    # Ensure there are players in the game
    return winner_user
  end

  def questions_content
    string = questions.map do |question|
      question.content
    end
    string.join("; ")

  end
end
