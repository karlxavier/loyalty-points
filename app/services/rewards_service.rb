class RewardsService

  def initialize(user: nil)
    @user = user
  end

  def issuing!
    begin
      rewards.order(:id).each do |reward|
        next if !rewarded?(reward)

        UserReward.create!(
          user: @user,
          reward: reward
        )
      end
    rescue => e
      puts "ERROR:: #{e}"
    end
  end

  private

  def rewarded?(reward)
    return @user.birthmonth? if reward.per_birthmonth?
    return monthly_points_accumulation?(reward)
    return per_transaction_points?(reward)
    return per_first_days_transactions?(reward)
    return false
  end

  def rewards
    @rewards ||= Reward.all
  end

  def active_transactions
    @active_transactions ||= @user.active_transactions
  end

  def monthly_points_accumulation?(reward)
    return false if reward.points_needed.blank?
    from_date = DateTime.now - reward.per_monthly_accumulation.months
    accumulated_points = @user.points_accumulation(from_date, DateTime.now)
    accumulated_points >= reward.points_needed
  end

  def per_transaction_points?(reward)
    return false if reward.points_needed.blank? || reward.per_transaction.blank?
    trans = active_transactions.where(cash_transactions: { amount: reward.points_needed..Float::INFINITY })
    return false unless trans.count >= reward.per_transaction
    trans.update_all(converted: true)
    return true
  end

  def per_first_days_transactions?(reward)
    return false if reward.per_first_days_transactions.blank?
    trans = active_transactions.order(:id).limit(reward.per_first_days_transactions)
    trans.sum("cash_transactions.amount") >= reward.points_needed
  end

end