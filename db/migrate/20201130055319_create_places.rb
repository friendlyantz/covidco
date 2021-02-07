class CreatePlaces < ActiveRecord::Migration[6.0]
  def change
    create_table :places do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.text :description
      t.string :business_hours
      t.string :price
      t.string :category
      t.float :covid_score
      t.references :location

      t.timestamps
    end
  end
end
