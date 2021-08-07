class AddColumnForeignToTransactionAndPoint < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_transactions, :foreign, :boolean, default: false
    add_reference :points, :cash_transaction, references: :ref_points_transactions, index: true
  end
end
