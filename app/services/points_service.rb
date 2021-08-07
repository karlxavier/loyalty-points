module PointsService
  class Base
    def initialize(user: nil, point: nil)
      @user = user
      @point = point
    end
  end

  class Debit < Base
    def update!
      @user.decrement!(:balance_points, @point.value)
    end
  end

  class Credit < Base
    def update!
      @user.increment!(:balance_points, @point.value)
    end
  end
end