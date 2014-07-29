class Call < ActiveRecord::Base
  def bid
    return nil if bs?
    Bid.new number, face_value
  end
end
