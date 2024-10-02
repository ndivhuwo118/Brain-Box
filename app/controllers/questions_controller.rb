class QuestionsController < ApplicationController

  def show
    @game = Game.find(params[:game_id])
    @round = @game.rounds.find(params[:round_id])
    @question = @round.questions.find(params[:id])
  end
end
