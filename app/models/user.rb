class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :owned_games, class_name: "Game", foreign_key: "owner_id"
  has_many :games, through: :players
  has_many :invites
  has_many :players

  after_create :claim_invites

  def name
    ret = read_attribute(:name)
    ret = email if ret.blank?

    ret
  end

  def claim_invites
    Invite.where(email: email).update_all(user_id: id)
  end

  def owns?(game)
    game.owner_id == id
  end
end
