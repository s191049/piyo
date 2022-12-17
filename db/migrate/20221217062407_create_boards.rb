class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.string :title, null: false
      t.string :name
      t.text :body, null: false

      t.timestamps
    end
  end
end
