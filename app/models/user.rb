class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum tier: %i[standard gold platinum]

  LOYALTY_TIERS = { standard: 0, gold: 1000, platinum: 5000 }

  has_many :cash_transactions
  has_many :points
  has_many :user_rewards

  validates_presence_of :birthdate

  # after_commit :tier_upgrade?, on: :create

  scope :points_accumulation, -> (user_id, from, to) {
    joins(:points).where(
      points: { created_at: from..to, user_id: user_id }
    ).sum("points.value")
  }

  def birthmonth?
    self.birthdate.strftime("%-m").to_i == Time.now.month
  end

  def active_transactions
    self.cash_transactions.where( converted: false )
  end

  def points_accumulation(from = nil, to = nil)
    self.points.where( created_at: from..to ).sum("points.value")
  end

  def check_tier_upgrade
      User::LOYALTY_TIERS.values.reverse.each do |point|
        if (self.balance_points.presence || 0) >= point
          self.tier = User::LOYALTY_TIERS.key(point)
          self.save
          break
        end
      end
  end

end
