class InvitationsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :except => [ :list_invitations_addressed_to_me,
                                               :accept ]

  def new
    @invitation = @group.invitations.build
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
    if(invitation.user_email == current_user.email &&
       params[:secure_token] == invitation.secure_token)
      Membership.create! group_id: params[:group_id], user_id: current_user.id
      invitation.destroy
    end

    unless current_user.invitations_addressed_to_me.empty?
      redirect_to list_invitations_addressed_to_me_path
    else
      redirect_to dashboard_path
    end
  end

  private

  def authorized_user
    @group = Group.find params[:group_id]
    redirect_to root_path unless current_user.groups.include? @group
  end
end
