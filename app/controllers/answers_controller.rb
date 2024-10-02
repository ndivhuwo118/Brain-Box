class AnswersController < ApplicationController

  def create
    @game = Game.find(params[:game_id])
    @round = @game.rounds.find(params[:round_id])
    @question = @round.questions.find(params[:question_id])
    @answer = @question.answers.find(params[:answer_id])
    # if @answer.correct?
  end
end
