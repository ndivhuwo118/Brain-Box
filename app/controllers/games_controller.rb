class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def index
    @games = []
    @game_players = GamePlayer.where(user_id: current_user.id)
    @game_players.each do |game_player|
      @games << game_player.game
    end
  end

  def show
    @game_players = @game.game_players.includes(:user)
    @rounds = @game.rounds.includes(:questions)
  end

  def new
    @categories = Category.all
    @users = []
    User.all.each do |user|
      if user != current_user
        @users << user.email
      end
    end
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.user = current_user

    # raise
    if @game.save
      @gp = GamePlayer.new(game: @game, user: current_user)
      @gp.save
      @gp = GamePlayer.new(game: @game, user: User.find_by(email: game_params[:user_id]))
      @gp.save
      redirect_to @game
    else
      render :new
    end
  end

  def play
    @game = Game.find(params[:id])
    @game.start_round!
    redirect_to game_round_path(@game, @game.current_round), notice: "Game has started!"
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:user_id, category_ids: [])
  end
end
