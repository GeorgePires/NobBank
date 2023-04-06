class AddDestinyAccountToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :destiny_account, :string
  end
end
