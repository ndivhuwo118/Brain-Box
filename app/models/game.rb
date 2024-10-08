class Game < ApplicationRecord
  after_save :set_rounds, unless: :seeding?
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
    SetRoundsJob.perform_later(self)
  end

  def current_round
    rounds.order(:round_number).last
  end
end
