class LineScore < ActiveRecord::Base
  def sum
    one + two + three + four + five
  end
end
