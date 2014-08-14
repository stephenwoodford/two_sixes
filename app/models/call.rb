class Call < ActiveRecord::Base
  belongs_to :player
  belongs_to :round

  def bid
    return nil if bs?
    Bid.new number, face_value
  end
end
