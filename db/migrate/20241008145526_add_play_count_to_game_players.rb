class AddPlayCountToGamePlayers < ActiveRecord::Migration[7.2]
  def change
    add_column :game_players, :play_count, :integer, default: 0
  end
end
