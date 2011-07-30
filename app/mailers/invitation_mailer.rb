class InvitationMailer < ActionMailer::Base
  default from: "inviterobot@magichat.herokuapp.com"

  def send_message(invitation)
    @invitation = invitation
    @group = Group.find(@invitation.group_id)
    mail( to: @invitation.user_email,
          subject: "You have been invited to join the group '#{@group.name}' On Magic Hat")
  end
end
