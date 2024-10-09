class Question < ApplicationRecord
  after_create :set_content, unless: :seeding?
  belongs_to :round
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers


  private


  def seeding?
    ENV['SEEDING'] == 'true'
  end

  def set_content
    categories = round.game.categories

    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [{ role: "user", content: "Give me an interesting quiz question in the category of #{categories.sample.name}. Give me only the text of the question, without any of your own answer like 'Here is a simple question'. Please make a question unique to the previous questions. Here are the other questions: #{round.game.questions_content}"}]
    })
    new_content = chatgpt_response["choices"][0]["message"]["content"]

    update(content: new_content)
    # return new_content

    answer1_response = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [
        { role: "user", content: "For the question: '#{content}', provide an incorrect answer. Do not include any additional text or methods" }
      ]
    })

    answer1 = answer1_response["choices"][0]["message"]["content"]

    answer2_response = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [
        { role: "user", content: "For the question: '#{content}', provide an incorrect answer. Make it different to this incorrect answer: #{answer1}.Do not include any additional text or methods" }
      ]
    })

    answer2 = answer2_response["choices"][0]["message"]["content"]


    answer4_response = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [
        { role: "user", content: "For the question: '#{content}', provide a one correct answer. Do not include any additional text or methods. These are the incorrect answers: #{answer1}, #{answer2}. Provide the correct answer in the same format as the incorrect ones" }
      ]
    })

    answer4 = answer4_response["choices"][0]["message"]["content"]


    # Create answers for the question
    Answer.create(question_id: self.id, content: answer1, decoy: true)
    Answer.create( question_id: self.id, content: answer2, decoy: true)
    Answer.create( question_id: self.id, content: answer4, decoy: false)



  end
end
