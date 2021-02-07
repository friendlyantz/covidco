class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|

      # t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :place, null: false, foreign_key: true
      t.string :tip

      t.integer :covid_rating

      # QnA - DEFAUL ENUM STATUS 0 - FOR 'NOT SURE / not answer'. 1-5 bad to good
      t.integer :hand_sanitizer, null: false, default: 0
      t.integer :face_mask, null: false, default: 0
      t.integer :temperature_checks, null: false, default: 0
      t.integer :social_distancing, null: false, default: 0
      t.integer :contract_tracing, null: false, default: 0

      t.integer :exposure_risk, null: false, default: 0
      t.integer :covid_consciousness, null: false, default: 0
      t.integer :covid_enforcement, null: false, default: 0
      t.integer :covid_creativity, null: false, default: 0

      t.timestamps
    end
  end
end
