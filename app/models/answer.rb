class Answer < ApplicationRecord
  belongs_to :question
  has_many :player_answers
  has_many :users, through: :player_answers

  validates :decoy, inclusion: { in: [true, false] }
  validate :only_one_correct_answer

  private

  def only_one_correct_answer
    if question.answers.where(decoy: false).exists? && !decoy
      errors.add(:base, 'Can only have one correct answer!')
    end
  end
end
