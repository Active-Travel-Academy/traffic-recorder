class CreatePointOfInterests < ActiveRecord::Migration[8.0]
  def change
    create_table :point_of_interests do |t|
      t.references :ltn, null: false, foreign_key: true
      t.float :lat, null: false
      t.float :lng, null: false
      t.string :name, null: false
      t.string :category

      t.timestamps
    end
  end
end
