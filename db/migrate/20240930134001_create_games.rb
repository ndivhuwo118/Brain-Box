class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.references :user, null: false, foreign_key: true
      t.references :winner, foreign_key: { to_table: :users}

      t.timestamps
    end
  end
end
