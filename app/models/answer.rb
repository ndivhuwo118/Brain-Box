class Answer < ApplicationRecord
  belongs_to :question
  after_save :content, unless: :seeding?
  has_many :player_answers
  has_many :users, through: :player_answers

  validates :decoy, inclusion: { in: [true, false] }
  validate :only_one_correct_answer

  private

  def other_answers
    question.answers.join('; ')
  end

  def only_one_correct_answer
    if question.answers.where(decoy: false).exists? && !decoy
      errors.add(:base, 'Can only have one correct answer!')
    end
  end

  def content
    if super.blank?
      set_content
    else
      super
    end
  end

  def seeding?
    ENV['SEEDING'] == 'true'
  end

  def set_content
    new_content = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [
        { role: "user", content: "For the question: '#{question.content}', provide a one sentence #{decoy ? "incorrect" : "correct"} answer. Do not include any additional text or methods or #{other_answers.any? ? other_answers : 'anything'}." }
      ]
    })

    new_content
  end
end
