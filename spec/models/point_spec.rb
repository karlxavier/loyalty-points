require 'rails_helper'

RSpec.describe Point, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:cash_transaction) { { user_id: user.id, amount: 1100 } }

  describe 'update balance' do
    it 'will update user balance points after create' do
      transaction = CashTransaction.create!(cash_transaction)
      point = transaction.points.first  

      expect(point.value).to eq(110)
      expect(transaction.user.balance_points).to eq(110)

      cash_transaction[:amount] = 400
      transaction = CashTransaction.create!(cash_transaction)
      expect(transaction.user.balance_points).to eq(150)
    end
  end
end