class UserReward < ApplicationRecord
  belongs_to :user
  belongs_to :reward

  validates_presence_of :user_id, :reward_id
end
