class AnswersController < ApplicationController


  def select
    @game = Game.find(params[:game_id])
    @round = Round.find(params[:round_id])
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])

    redirect_to game_round_path(@game, @round), notice: 'Your answer has been recorded.'
  end


end
