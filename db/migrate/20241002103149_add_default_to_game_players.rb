class AddDefaultToGamePlayers < ActiveRecord::Migration[7.2]
  def change
    change_column :game_players, :score, :integer, default: 0
  end
end
