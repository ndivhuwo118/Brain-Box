class QuestionsController < ApplicationController

  def show
    @questions = Question.find(params[:id])
    @answers = @questions.answers
  end
end
