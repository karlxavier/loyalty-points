user = User.create!(
  email: 'usertest1@test.com',
  password: 'password',
  birthdate: DateTime.now + 1.month
)

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

