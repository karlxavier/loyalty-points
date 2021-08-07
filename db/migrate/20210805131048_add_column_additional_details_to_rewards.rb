class AddColumnAdditionalDetailsToRewards < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards, :per_transaction, :integer, default: nil
    add_column :rewards, :per_monthly_accumulation, :integer, default: nil
    add_column :rewards, :per_birthmonth, :boolean, default: false
    add_column :rewards, :per_first_days_transactions, :integer, default: nil
    add_column :points, :rewarded, :boolean, default: false
    add_column :cash_transactions, :converted, :boolean, default: false
  end
end
