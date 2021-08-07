class AddColumnPerTierReward < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards, :per_gold_tier, :boolean, default: false
  end
end
