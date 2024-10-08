class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.timestamps
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
    end
  end
end
