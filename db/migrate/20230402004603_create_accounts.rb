class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :account_number, null: false
      t.decimal :balance, default: 0.0, null: false
      t.boolean :status, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
