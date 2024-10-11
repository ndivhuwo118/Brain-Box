class UsersController < ApplicationController

  def search
    @users = User.where('name LIKE ?', "%#{params[:query]}%").limit(10)
    render json: @users
  end

  def show
    @other_user = User.find_by(nickname: params[:nickname])
    @shared_games = Game.shared_between(current_user, @other_user)

    @my_games = @shared_games.joins(:game_players)
                      .where(game_players: { user_id: current_user.id, played: false })
                      .group('games.id, game_players.id')

    @started_games = Game.joins(:game_players)
    .where(game_players: { user_id: current_user.id, played: true })  # Current user has played
    .where.not(id: Game.joins(:game_players)
                        .where("game_players.user_id != ?", current_user.id)  # Ensure we are checking for the opponent
                        .where(game_players: { played: true }))  # Exclude games where the opponent has played
    .group('games.id')




    # Games that both players have completed (assuming complete? is a model method)
    @complete_games = @shared_games.select { |game| game.complete? }

  end

end
