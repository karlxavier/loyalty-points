class AddColumnDateUsedToUserReward < ActiveRecord::Migration[5.2]
  def change
    add_column :user_rewards, :date_used, :datetime
  end
end
