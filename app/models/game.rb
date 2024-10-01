class Game < ApplicationRecord
  belongs_to :user
  has_many :game_players
  has_many :rounds
  has_many :game_catergories
  has_many :users, through: :game_players, as: :players
end
