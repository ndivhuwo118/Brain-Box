class GamesController < ApplicationController
 before_action :set_game, only: [:show, :create]

  def index
    @games = Game.all
  end

  def show
    @game_players = @game.game_players.includes(:user)
    @rounds = @game.rounds.includes(:questions)
  end

  def new
    @game = Game.new
    @categories = Category.all
    @users = User.all
  end

  def create
    @game = Game.new(game_params)
    @game.save
    redirect_to game_path(@game)
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:user_id, :winner_id)
  end
end
