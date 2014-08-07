class Invite < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  validates_uniqueness_of :email, scope: :game_id
  validates :email, presence: true, email: true

  scope :accepted, -> { where("accepted_at IS NOT NULL") }
  scope :declined, -> { where("declined_at IS NOT NULL") }
  scope :open, -> { where(accepted_at: nil, declined_at: nil, revoked_at: nil) }
  scope :revoked, -> { where("revoked_at IS NOT NULL") }

  def game_owner
    game.owner
  end

  def accept(handle)
    return if accepted?
    raise UsageError("Unable to accept a revoked invite") if revoked?
    raise UsageError("Unable to accept an invite after game has started") if game.started?

    game.add_player(user, handle)
    update_attributes(accepted_at: Time.now, declined_at: nil, revoked_at: nil)
  end

  def decline
    return if revoked? || declined?
    raise UsageError("Unable to decline an accepted invite") if accepted?
    raise UsageError("Unable to decline an invite after game has started") if game.started?

    update_attributes(declined_at: Time.now)
  end

  def revoke
    return if revoked?
    raise UsageError("Unable to revoke an accepted invite") if accepted?

    update_attributes(declined_at: nil, revoked_at: Time.now)
  end

  def accepted?
    !!accepted_at
  end

  def declined?
    !!declined_at
  end

  def open?
    !accepted? && !declined? && !revoked?
  end

  def revoked?
    !!revoked_at
  end
end
