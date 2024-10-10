class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :game
  has_many :game_players
  has_many :player_answers
  has_many :games_as_opponent, class_name: 'Game', foreign_key: 'opponent_id'
  has_many :messages
  has_one_attached :avatar

  def total_score
    game_players.sum(:score)
  end
end
