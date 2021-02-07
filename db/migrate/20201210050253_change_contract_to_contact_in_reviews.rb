class ChangeContractToContactInReviews < ActiveRecord::Migration[6.0]
  def change
    rename_column :reviews, :contract_tracing, :contact_tracing
  end
end
