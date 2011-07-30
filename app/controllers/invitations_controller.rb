class InvitationsController < ApplicationController

  def new
    group = Group.find params[:group_id]
    @invitation = group.invitations.build
  end

  def create
    invitation = Invitation.new params[:invitation]
    if invitation.save
      flash[:success] = "Invite sent!"
      redirect_to invitation.group
    else
      render :new
    end
  end

  def list_invitations_addressed_to_me
    @invitations = Invitation.where user_email: current_user.email
  end
end
