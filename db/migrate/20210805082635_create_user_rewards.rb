class CreateUserRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :user_rewards do |t|
      t.references :user
      t.references :reward
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
