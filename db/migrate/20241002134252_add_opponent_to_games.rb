class AddOpponentToGames < ActiveRecord::Migration[7.2]
  def change
    add_reference :games, :opponent, foreign_key: { to_table: :users }
  end
end
