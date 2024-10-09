class Question < ApplicationRecord
  after_save :content, unless: :seeding?
  belongs_to :round
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers



  def content
    if super.blank?
      set_content
    else
      super
    end
  end

  private

  def seeding?
    ENV['SEEDING'] == 'true'
  end

  def set_content
    categories = round.game.categories

    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [{ role: "user", content: "Give me a trivia question with the category of #{categories.sample.name}. Give me only the text of the question, without any of your own answer like 'Here is a simple question'."}]
    })
    new_content = chatgpt_response["choices"][0]["message"]["content"]

    update(content: new_content)
    # return new_content

    answer_response = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [
        { role: "user", content: "For the question: '#{new_content}', provide one correct answer and two wrong answers. Do not include any additional text or methods, just three short sentence answers." }
      ]
    })

    answer_texts = answer_response["choices"][0]["message"]["content"].split("\n").reject(&:empty?)

    correct_answer = answer_texts[0] # Assuming first answer is correct
    decoy_answers = answer_texts[1..2] # Assuming the next two are decoys

    # Create answers for the question
    answers.create([
      { content: correct_answer, decoy: false },
      { content: decoy_answers[0], decoy: true },
      { content: decoy_answers[1], decoy: true }
    ])

    new_content
  end

end
