class Point < ApplicationRecord
  belongs_to :user
  belongs_to :cash_transaction

  enum account_type: %i[debit credit]

  validates_presence_of :user_id, :value, :cash_transaction_id

  after_create :update_user_balance, :check_for_rewards

  POINTS_AMOUNT_CONVERTION = { points: 10, amount: 100 }

  private

  def update_user_balance
    service = "PointsService::#{account_type.camelize}".constantize.new(user: user, point: self)
    service.update!
  end

  def check_for_rewards
    service = RewardsService.new(user: user)
    service.issuing!
  end
end
