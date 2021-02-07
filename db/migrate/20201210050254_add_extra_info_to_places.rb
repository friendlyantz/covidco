class AddExtraInfoToPlaces < ActiveRecord::Migration[6.0]
  def change
    add_column :places, :title, :string
    add_column :places, :rating, :float
    add_column :places, :website, :string
    add_column :places, :phone, :string
  end
end
