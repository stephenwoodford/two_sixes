class UserMailer < ActionMailer::Base
  default from: 'DICE! <dice@example.com>'

  def invite(invite)
    @invite = invite

    mail(to: @invite.email, subject: "Dice? Invite from #{@invite.game.owner.name}")
  end
end
