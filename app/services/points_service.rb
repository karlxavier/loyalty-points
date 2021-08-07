module PointsService
  class Base

    attr_accessor :user, :loyal_point

    def initialize(user: nil, point: nil)
      @user = user
      @loyal_point = point
    end
  end

  class Debit < Base
    def update!
      @user.decrement!(:balance_points, @loyal_point.value)
    end
  end

  class Credit < Base
    def update!
      @user.increment!(:balance_points, @loyal_point.value)
      @user.check_tier_upgrade
    end
  end
end