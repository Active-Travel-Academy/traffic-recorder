class AddOriginAndPoiToJourneys < ActiveRecord::Migration[8.0]
  def change
    add_reference :journeys, :origin, null: true, foreign_key: { on_delete: :nullify }
    add_reference :journeys, :point_of_interest, null: true, foreign_key: { on_delete: :nullify }, index: false
    add_index :journeys, %i[point_of_interest_id origin_id], unique: true, name: 'index_journeys_on_origin_and_poi'
  end
end
