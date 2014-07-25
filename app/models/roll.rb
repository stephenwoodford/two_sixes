class Roll < ActiveRecord::Base
  belongs_to :round
  belongs_to :player

  def count(face, wild=true)
    raise ArgumentError.new("Invalid face value: #{face}") unless face >= 1 && face <= 6

    ret = dice[face]
    ret += dice[1] if wild && face != 1

    ret
  end

  def dice
    unless @dice
      parsed = dice_string.split("-").map(&:to_i)
      # Map (1..6) to an array of 2 elt arrays [[1, ones], [2, twos], ...]
      # flattening that gives an array [1, ones, 2, twos, ...] and splatting that
      # to Hash[] gives a hash {1 => ones, 2 => twos, ...}
      @dice = Hash[*(1.upto(6).map{|i| [i, parsed.count{|elt| elt == i}]}.flatten)]
    end

    @dice
  end
end
