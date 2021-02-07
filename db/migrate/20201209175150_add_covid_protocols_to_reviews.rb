class AddCovidProtocolsToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :covid_protocols, :integer
  end
end
