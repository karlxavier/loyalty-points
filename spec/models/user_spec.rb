require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:cash_transaction) { { user_id: user.id, amount: 1100 } }

  describe 'create' do
    it 'has a default standard tier' do
      expect(user.standard?).to eq(true)
    end

    it 'will upgrade tier to gold if user accumulates 1000 points' do
      cash_transaction[:amount] = 11000
      transaction = CashTransaction.create!(cash_transaction)
      user.reload

      expect(user.gold?).to eq(true) 
    end

    it 'will upgrade tier to gold if user accumulates 1000 points' do
      cash_transaction[:amount] = 51000
      transaction = CashTransaction.create!(cash_transaction)
      user.reload

      expect(user.platinum?).to eq(true) 
    end
  end
end