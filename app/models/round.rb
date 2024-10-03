class Round < ApplicationRecord
  after_save :set_question
  belongs_to :game
  has_one :question

  private

  def set_question
    Question.create(round_id: self.id)
  end

end
