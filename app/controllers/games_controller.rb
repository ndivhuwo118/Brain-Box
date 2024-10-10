class GamesController < ApplicationController
  before_action :set_game, only: [:show]
  def index
    # Fetch all games where the user is either the main user or the opponent
    @games = Game.where("games.user_id = ? OR games.opponent_id = ?", current_user.id, current_user.id)

    # Games that the current user hasn't played
    @my_games = @games.joins(:game_players)
                      .where(game_players: { user_id: current_user.id, played: false })
                      .group('games.id, game_players.id')

    @started_games = Game.joins(:game_players)
    .where(game_players: { user_id: current_user.id, played: true })  # Current user has played
    .where.not(id: Game.joins(:game_players)
                        .where("game_players.user_id != ?", current_user.id)  # Ensure we are checking for the opponent
                        .where(game_players: { played: true }))  # Exclude games where the opponent has played
    .group('games.id')




    # Games that both players have completed (assuming complete? is a model method)
    @complete_games = @games.select { |game| game.complete? }
  end



  def show
    @game_players = @game.game_players.includes(:user)
    @rounds = @game.rounds.includes(:questions)
    @message = Message.new
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
    if current_user == @game.current_player.user
      @score = @game.current_player.score
    else
      @score = @game.opponent_player.score
    end
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
