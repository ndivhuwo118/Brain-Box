class QuestionsController < ApplicationController

  def show
    @game = Game.find(params[:game_id])
    @round = @game.rounds.find(params[:round_id])
    @question = @round.questions.find(params[:id])
  end

  # def answer
  #   @game = Game.find(params[:game_id])
  #   @round = Round.find(params[:round_id])
  #   @question = Question.find(params[:id])
  #   @answer = Answer.find(params[:answer_id])
  # end
end
