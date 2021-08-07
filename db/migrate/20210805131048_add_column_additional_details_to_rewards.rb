class AddColumnAdditionalDetailsToRewards < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards, :per_transaction, :integer, default: 0
    add_column :rewards, :per_monthly_accumulation, :integer, default: 0
    add_column :rewards, :per_birthmonth, :boolean, default: false
    add_column :rewards, :per_first_days_transactions, :integer, default: 0
    add_column :points, :rewarded, :boolean, default: false
    add_column :cash_transactions, :converted, :boolean, default: false
  end
end
