class DieLostEvent < ActiveRecord::Base
  belongs_to :round
  belongs_to :player

  def to_hash
    { seat: player.seat }
  end
end
