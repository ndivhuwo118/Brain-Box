class Answer < ApplicationRecord
  belongs_to :question
  has_many :player_answers
  belongs_to :user, through: :player_answers
end
