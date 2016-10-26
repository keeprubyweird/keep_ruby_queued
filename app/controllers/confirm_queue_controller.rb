class ConfirmQueueController < ApplicationController

  def show
    @user = QueuedUser.find(queued_user_params[:id])
    if @user.valid_token?(queued_user_params[:confirm_token])
      @user.confirmed = true
      @user.queued_at ||= Time.now
      @user.save!
      redirect_to queued_user_path(@user), notice: "Confirmation success"
    else
      redirect_to queued_user_path(@user), notice: "Confirmation Failed"
    end
  end

  def create
    @user = QueuedUser.find(queued_user_params[:id])
    if @user.valid_token?(queued_user_params[:confirm_token])
      @user.send_confirmation!
      redirect_to queued_user_path(@user), notice: "Confirmation re-sent"
    else
      redirect_to queued_user_path(@user), notice: "Invalid credentials"
    end
  end

  private
    def queued_user_params
      params.permit(:id, :confirm_token)
    end
end
