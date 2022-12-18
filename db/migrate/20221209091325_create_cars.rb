class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.integer :division
      t.integer :oil_type
      t.integer :number
      t.string :color
      t.string :model_mfr
      t.string :area
      t.string :hiragana
      t.string :class_num
      t.string :remarks

      t.timestamps
    end
  end
end
