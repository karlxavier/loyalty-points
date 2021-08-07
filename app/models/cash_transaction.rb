class CashTransaction < ApplicationRecord
  belongs_to :user
  has_many :points

  validates_presence_of :user_id, :amount

  after_create :set_loyalty_points

  private

  def set_loyalty_points
    begin
      Point.create!(
        user: user,
        cash_transaction_id: id,
        value: loyalty_points,
        account_type: Point.account_types[:credit],
      ) if amount >= Point::POINTS_AMOUNT_CONVERTION[:amount]
    rescue => e
      puts "ERROR:: #{e}"
    end
  end

  def loyalty_points
    points = amount / Point::POINTS_AMOUNT_CONVERTION[:points]
    points = points * 2 if foreign?
    points
  end
end
