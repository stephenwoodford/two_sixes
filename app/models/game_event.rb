class GameEvent < ActiveRecord::Base
  belongs_to :game

  belongs_to :action, polymorphic: true
end
