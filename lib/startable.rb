module Startable
  def start
    raise ArgumentError.new("Unable to start an already started #{self.class}.") if started?

    before_start if defined?(self.before_start)
    update_attributes(started_at: Time.now)
    after_start if defined?(self.after_start)
  end

  def started?
    !!started_at
  end

  def finish
    raise ArgumentError.new "Unable to finish an already finished #{self.class}." if finished?
    raise ArgumentError.new "Unable to finish a #{self.class} before it starts." unless started?

    before_finish if defined?(self.before_finish)
    update_attributes(finished_at: Time.now)
    after_finish if defined?(self.after_finish)
  end

  def finished?
    !!finished_at
  end

  def in_progress?
    started? && !finished?
  end
end
