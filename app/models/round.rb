class Round < ApplicationRecord
  belongs_to :game
  has_one :question
end
