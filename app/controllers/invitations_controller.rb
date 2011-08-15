class InvitationsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :except => [ :list_invitations_addressed_to_me,
                                               :accept ]

  def new
    @invitation = @group.invitations.build
  end

  def create
    # XXX Move to a method on the model
    invitation = Invitation.new params[:invitation].
                 merge(secure_token: SecureRandom.base64(10))
    # XXX Move to a method on the model
    if Invitation.where(user_email: invitation.user_email,
                        group_id: invitation.group_id).
                  empty? or not
             User.find_by_email(invitation.user_email).
                  groups.
                  include?(invitation.group)
      if invitation.save
        flash[:success] = "Invite sent!"
        InvitationMailer.send_message(invitation).deliver
        redirect_to invitation.group
      else
        render :new
      end
    else
      flash[:success] = "Invite sent!"
      redirect_to invitation.group
    end
  end

  def resend
    invitation = Invitation.find params[:id]
    InvitationMailer.send_message(invitation).deliver
    flash[:success] = "Invite re-sent!"
    redirect_to invitation.group
  end

  def list_invitations_addressed_to_me
    @invitations = Invitation.where user_email: current_user.email
  end

  def accept
    invitation = Invitation.find params[:id]
    group = Group.find(invitation.group_id)
    if(invitation.user_email == current_user.email &&
       params[:secure_token] == invitation.secure_token)
      Membership.create! group_id: params[:group_id], user_id: current_user.id
      invitation.destroy
    end

    unless current_user.invitations_addressed_to_me.empty?
      redirect_to list_invitations_addressed_to_me_path
    else
      redirect_to group
    end
  end

  def destroy
    invitation = Invitation.find params[:id]
    group = Group.find params[:group_id]
    invitation.destroy
    flash[:success] = "Invitation deleted!"
    redirect_to group
  end

  private

  def authorized_user
    @group = Group.find params[:group_id]
    redirect_to root_path unless current_user.groups.include? @group
  end
end
