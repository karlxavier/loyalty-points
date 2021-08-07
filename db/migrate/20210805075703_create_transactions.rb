class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_transactions do |t|
      t.references :user
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.text :description

      t.timestamps
    end
  end
end
