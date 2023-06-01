class CreateCounters < ActiveRecord::Migration[7.0]
  def change
    create_table :counters do |t|
      t.references :car, null: false, foreign_key: true
      t.integer :visit_count, default: 1

      t.timestamps
    end
  end
end
