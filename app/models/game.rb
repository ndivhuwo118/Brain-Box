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

end
