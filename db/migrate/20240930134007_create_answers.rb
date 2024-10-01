class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers do |t|
      t.string :content
      t.boolean :decoy
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
