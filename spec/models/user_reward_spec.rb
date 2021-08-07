require 'rails_helper'
require 'database_cleaner/active_record'

RSpec.describe UserReward, type: :model do

  describe 'check for rewards' do
    DatabaseCleaner.strategy = [:truncation, only: %w[user_rewards rewards]]
    DatabaseCleaner.clean

    let(:user) { FactoryBot.create(:user) }
    let(:cash_transaction) { { user_id: user.id, amount: 1100 } }

    rewards = [
      { # A Free Coffee reward is given to all users during their birthday month
        name: 'Free Coffee',
        per_birthmonth: true
      },
      { # If the end user accumulates 100 points in one calendar month they are given a Free Coffee reward
        name: 'Free Coffee',
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
      }
    ]
    
    rewards.each do |reward|
      Reward.create!(reward)
    end

    it 'Free Coffee reward is given to all users during their birthday month' do
      user.update_attributes!(birthdate: DateTime.now)
      cash_transaction[:amount] = 100
      transaction = CashTransaction.create!(cash_transaction)
      user_rewards = transaction.user.user_rewards

      expect(user_rewards.last.reward.name).to eq('Free Coffee')
    end

    it 'Free Coffee reward is given if user have 100 points in one calendar month' do
      transaction = CashTransaction.create!(cash_transaction)
      user_rewards = transaction.user.user_rewards

      expect(user_rewards.last.reward.name).to eq('Free Coffee')
    end

    it '5% Cash Rebate to all users who have 10 or more transactions that have an amount > $100' do
      1.upto(10) do |tran|
        cash_transaction[:amount] = 110
        CashTransaction.create!(cash_transaction)
      end
      
      expect(user.cash_transactions.count).to eq(10)
      expect(user.points.count).to eq(10)
      expect(user.user_rewards.count).to eq(1)
      expect(user.user_rewards.joins(:reward).pluck(:"rewards.name")).to include('5% Cash Rebate')
    end
  end
end