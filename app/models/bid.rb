class Bid
  attr_reader :face_value, :number

  def initialize(number, face_value)
    @face_value = face_value
    @number = number
  end

  def >(bid)
    return true if bid.nil?

    if number == bid.number
      face_value > bid.face_value
    else
      number > bid.number
    end
  end
end
