class Answer < ApplicationRecord
  belongs_to :question
  has_many :player_answers
  has_many :users, through: :player_answers

  validate :only_one_correct_answer

  private

  def only_one_correct_answer
    if question.answers.where(decoy: false).count >= 1 && decoy
      errors.add(:decoy, "Can only have one correct answer!")
    end
  end

  # def validate_content
  #   # Ensure that the answer has been set properly.
  #   if content.blank?
  #     set_default_content
  #   end
  # end

  # def set_default_content
  #   # Here you can set a default value or handle errors.
  #   # For example, you could log a warning if an answer is saved without content.
  #   Rails.logger.warn("Answer for question ID #{question.id} was saved without content.")
  # end
end
