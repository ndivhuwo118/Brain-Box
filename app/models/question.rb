class Question < ApplicationRecord
  after_save :content
  belongs_to :round
  has_many :answers

  def content
    if super.blank?
      set_content
    else
      super
    end
  end

  private

  def set_content
    categories = round.game.categories
    p categories

    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [{ role: "user", content: "Give me a trivia question with the category of #{categories.sample.name}. Give me only the text of the question, without any of your own answer like 'Here is a simple question'."}]
    })
    new_content = chatgpt_response["choices"][0]["message"]["content"]

    update(content: new_content)
    return new_content
  end

end
