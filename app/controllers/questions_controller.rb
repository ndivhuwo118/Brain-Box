class QuestionsController < ApplicationController
  
  def show
    @questions = questions.find(params[:id])
    @answers = questions.answers
  end
end
