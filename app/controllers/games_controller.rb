class GamesController < ApplicationController
  def index
    @games = []
    @game_players = GamePlayer.where(user_id: current_user.id)
    @game_players.each do |game_player|
      @games << game_player.game
    end
  end
end
