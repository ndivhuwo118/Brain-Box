class Answer < ApplicationRecord
  belongs_to :question
  has_many :player_answers
  has_many :users, through: :player_answers

  validates :decoy, inclusion: { in: [true, false] }

end
