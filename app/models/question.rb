class Question < ApplicationRecord
  belongs_to :round
  has_many :answers

end
