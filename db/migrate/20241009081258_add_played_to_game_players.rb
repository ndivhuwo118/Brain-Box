class AddPlayedToGamePlayers < ActiveRecord::Migration[7.2]
  def change
    add_column :game_players, :played, :boolean, default: false
  end
end
