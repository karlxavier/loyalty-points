require 'rails_helper'

RSpec.describe CashTransaction, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:cash_transaction) { { user_id: user.id, amount: 1100 } }

  describe 'create' do

    it 'can create' do
      transaction = CashTransaction.create!(cash_transaction)
      expect(transaction.user_id).to eq(user.id)
    end

    it 'will create points after transaction creation' do
      transaction = CashTransaction.create!(cash_transaction)
      point = transaction.points.first

      expect(point.value).to eq(110)
    end

    it 'will double the loyalty points if its foreign' do
      cash_transaction[:foreign] = true
      transaction = CashTransaction.create!(cash_transaction)
      point = transaction.points.first

      expect(point.value).to eq(220)
    end

    it 'will not create points if amount is less than 100' do
      cash_transaction[:amount] = 20
      transaction = CashTransaction.create!(cash_transaction)
      points = transaction.points

      expect(points.count).to eq(0)
    end
  end
end