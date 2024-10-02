class RoundsController < ApplicationController
  def show
    @game = Game.find(params[:game_id])
    @round = @game.rounds.find(params[:id])
    @question = @round.questions.first
  end

  def create
  end
end
