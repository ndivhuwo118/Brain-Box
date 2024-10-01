class CreateGamePlayers < ActiveRecord::Migration[7.2]
  def change
    create_table :game_players do |t|
      t.references :game, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
