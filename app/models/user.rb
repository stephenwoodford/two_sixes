class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :games, through: :players
  has_many :players

  def name
    ret = read_attribute(:name)
    ret = email if ret.blank?

    ret
  end
end
