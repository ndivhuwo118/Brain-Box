class CreatePlayersAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :players_answers do |t|
      t.integer :answer_id
      t.integer :user_id
      t.boolean :correct
      t.integer :round_id

      t.timestamps
    end
  end
end
