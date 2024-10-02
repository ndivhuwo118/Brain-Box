class Game < ApplicationRecord
  belongs_to :user
  has_many :game_players
  has_many :rounds
  has_many :game_categories
  has_many :categories, through: :game_categories
  has_many :players, through: :game_players, source: :user

  def start_round!
    self.rounds.create(round_number: 1) unless self.rounds.exists?
  end

  def current_round
    rounds.order(:round_number).last
  end
end
