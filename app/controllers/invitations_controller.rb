class InvitationsController < ApplicationController

  def new
    group = Group.find params[:group_id]
    @invitation = group.invitations.build
  end

  def create
    invitation = Invitation.new params[:invitation]
    if invitation.save
      flash[:success] = "Invite sent!"
      InvitationMailer.send_message(invitation).deliver
      redirect_to invitation.group
    else
      render :new
    end
  end

  def list_invitations_addressed_to_me
    @invitations = Invitation.where user_email: current_user.email
  end

  def accept
    invitation = Invitation.find params[:id]
    Membership.create! group_id: params[:group_id], user_id: current_user.id

    invitation.destroy
    unless current_user.invitations_addressed_to_me.empty?
      redirect_to list_invitations_addressed_to_me_path
    else
      redirect_to dashboard_path
    end
  end
end
