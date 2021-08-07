require 'rails_helper'
require 'database_cleaner/active_record'

RSpec.describe UserReward, type: :model do

  describe 'check for rewards' do
    DatabaseCleaner.strategy = [:truncation, only: %w[user_rewards rewards]]
    DatabaseCleaner.clean

    let(:user) { FactoryBot.create(:user) }
    let(:cash_transaction) { { user_id: user.id, amount: 1001, converted: false } }

    rewards = [
      { # A Free Coffee reward is given to all users during their birthday month
        name: 'Free Coffee',
        per_birthmonth: true
      },
      { # If the end user accumulates 100 points in one calendar month they are given a Free Coffee reward
        name: 'Free Coffee 2',
        points_needed: 100,
        per_monthly_accumulation: 1
      },
      { # 5% Cash Rebate reward is given to all users who have 10 or more transactions that have an amount > $100
        name: '5% Cash Rebate',
        per_transaction: 10,
        points_needed: 100
      },
      { # A Free Movie Tickets reward is given to new users when their spending is > $1000 within 60 days of their first transaction
        name: 'Free Movie Tickets',
        per_first_days_transactions: 60, 
        points_needed: 1000
      },
      { # Give 4x Airport Lounge Access Reward when a user becomes a gold tier customer
        name: '4x Airport Lounge Access',
        per_gold_tier: true, 
      }
    ]
    
    rewards.each do |reward|
      Reward.create!(reward)
    end

    it 'Free Coffee reward is given to all users during their birthday month' do
      user.update_attributes!(birthdate: DateTime.now)
      cash_transaction[:amount] = 100
      transaction = CashTransaction.create!(cash_transaction)

      expect(user.user_rewards.last.reward.name).to eq('Free Coffee')
    end

    it 'Free Coffee reward is given if user have 100 points in one calendar month' do
      transaction = CashTransaction.create!(cash_transaction)

      expect(user.user_rewards.count).to eq(2)
      expect(user.user_rewards.joins(:reward).pluck(:"rewards.name")).to include('Free Coffee 2')
    end

    it '5% Cash Rebate to all users who have 10 or more transactions that have an amount > $100' do
      1.upto(12) do |tran|
        cash_transaction[:amount] = 110
        CashTransaction.create!(cash_transaction)
      end
      
      expect(user.user_rewards.joins(:reward).pluck(:"rewards.name")).to include('5% Cash Rebate')
    end

    it 'Free Movie Tickets reward is given to new users when their spending is > $1000 within 60 days of their first transaction' do
      1.upto(59) do |tran|
        cash_transaction[:amount] = 17
        CashTransaction.create!(cash_transaction)
      end
      cash_transaction[:amount] = 101
      CashTransaction.create!(cash_transaction)

      expect(user.user_rewards.last.reward.name).to eq('Free Movie Tickets')
    end

    it 'Give 4x Airport Lounge Access Reward when a user becomes a gold tier customer' do
      cash_transaction[:amount] = 11000
      transaction = CashTransaction.create!(cash_transaction)

      expect(user.user_rewards.last.reward.name).to eq('4x Airport Lounge Access')
    end
  end
end