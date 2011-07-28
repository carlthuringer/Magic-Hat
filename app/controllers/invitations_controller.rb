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
end
