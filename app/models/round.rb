class Round < ApplicationRecord
  after_save :set_question, unless: :seeding?
  belongs_to :game
  has_one :question

  private

  def seeding?
    ENV['SEEDING'] == 'true'
  end

  def set_question
    Question.create(round_id: self.id)
  end

end
