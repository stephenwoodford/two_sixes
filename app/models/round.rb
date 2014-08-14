class Round < ActiveRecord::Base
  include Startable

  belongs_to :game
  belongs_to :starting_player, class_name: "Player"
  belongs_to :loser, class_name: "Player"

  has_many :calls
  has_many :players, through: :game
  has_many :rolls, dependent: :destroy

  scope :bids, ->{ calls.where(bs: false) }

  def to_hash
    {
      number: number,
      ones_wild: ones_wild
    }
  end

  def before_start
    players.order(:seat).each do |p|
      roll = roll_dice(p)
      game.add_event(roll)
    end
  end

  def after_finish
    event = DieLostEvent.new
    event.round = self
    if current_call.bs?
      event.final_number = total(current_bid.face_value)

      if current_bid_correct?
        self.loser = current_call.player
      else
        self.loser = previous_call.player
      end
    else
      self.loser = current_bid.player
    end
    save
    event.player = loser
    event.save

    loser.lose_die
    game.add_event(event)
  end

  def roll_dice(player)
    raise UsageError.new "Unable to roll after round has started." if started?

    roll = self.rolls.build(player: player)
    roll.dice = (0...player.dice_count).map{ Random.rand(6) + 1 }
    roll.save!

    player.update_attributes(roll: roll)

    roll
  end

  def current_call
    calls.order(:sequence_number).last
  end

  def previous_call
    calls.order(:sequence_number)[-2]
  end

  def current_bid
    return unless current_call

    if current_call.bs?
      previous_call.bid
    else
      current_call.bid
    end
  end

  def legal_bid?(bid)
    bid > current_bid
  end

  def bidder
    if current_call
      next_player current_call.player
    else
      starting_player
    end
  end

  def next_player(player)
    # Look up the next player by seat number
    next_seat = (player.seat + 1) % players.count
    player = players.find_by_seat next_seat

    if player.has_dice?
      player
    else
      # Since players without dice aren't removed from the round,
      # we need to explicitly skip them.
      next_player(player)
    end
  end

  def total(face_value)
    raise ArgumentError.new "Invalid face value (#{face_value})" unless (1..6).include? face_value

    rolls.map{|roll| roll.count(face_value, ones_wild?)}.reduce(:+)
  end

  def current_bid_correct?
    total(current_bid.face_value) >= current_bid.number
  end

  def bid(player, bid)
    raise UsageError.new "Unable to bid when round is not in progress." unless in_progress?

    legal = legal_bid? bid
    seq = current_call ? current_call.sequence_number + 1 : 0
    call = calls.create(number: bid.number, face_value: bid.face_value, bs: false, player: player, legal: legal, sequence_number: seq)
    update_attributes(ones_wild: false) if bid.face_value == 1
    game.add_event(call)

    legal
  end

  def bs(player)
    raise UsageError.new "Unable to call bs when round is not in progress." unless in_progress?

    seq = current_call ? current_call.sequence_number + 1 : 0
    call = calls.create(bs: true, player: player, sequence_number: seq)
    game.add_event(call)
  end
end
