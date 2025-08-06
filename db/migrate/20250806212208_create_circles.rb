class CreateCircles < ActiveRecord::Migration[8.0]
  def change
    create_table :circles do |t|
      t.decimal :center_x, precision: 10, scale: 2
      t.decimal :center_y, precision: 10, scale: 2
      t.decimal :diameter, precision: 10, scale: 2
      t.references :frame, null: false, foreign_key: true

      t.timestamps
    end
  end
end
