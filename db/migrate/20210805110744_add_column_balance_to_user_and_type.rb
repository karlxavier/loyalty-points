class AddColumnBalanceToUserAndType < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :balance_points, :integer
    add_column :points, :account_type, :integer, default: 0
  end
end
