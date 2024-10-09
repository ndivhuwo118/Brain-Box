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
        @users << user.nickname
      end
    end
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.user = current_user

    @opponent = User.find_by(nickname: game_params[:user_id])

    if @opponent.nil?
      flash[:alert] = "Opponent not found. Please select a valid opponent."
      render :new and return
    end

    @game.opponent_id = @opponent.id


    if @game.save
      GamePlayer.create!(game: @game, user: current_user)
      GamePlayer.create!(game: @game, user: @opponent)
      redirect_to loading_game_path(@game), notice: 'Game was successfully created.'
    else
      render :new
    end
  end

  def play
    @game = Game.find(params[:id])
    redirect_to game_round_path(@game, @game.rounds.first), notice: "Game has started!"
  end

  def loading
    @game = Game.find(params[:id])
    @first_round = @game.rounds.first
  end

  def results
    @game = Game.find(params[:id])
    @rounds = @game.rounds.count
    @score = @game.current_player.score
  end

  def final
    @game = Game.find(params[:id])
    @winner = @game.winner!
  end
  
  private

  def set_game
    @game = Game.find_by(id: params[:id])
    redirect_to games_path, alert: "Game not found." unless @game
  end

  def game_params
    params.require(:game).permit(:user_id, category_ids: [])
  end
end
