class AdminController < ApplicationController
  http_basic_authenticate_with name: 'admin', password: ENV.fetch('ADMIN_PASSWORD')

  def index
    @waiting_users  = QueuedUser.waiting_users.paginate(page: params[:page], per_page: params[:per_page] || 30)
    @notified_users = QueuedUser.where.not(notified_at: nil).where(finished_at: nil)
  end

  def create
    user = QueuedUser.waiting_users.first
    user.notified_at = Time.now
    user.save!
    user.you_are_next!
    redirect_back(fallback_location: '/admin')
  end

  def destroy
    user = QueuedUser.find(queued_user_params[:id])
    user.finished_at = Time.now
    redirect_back(fallback_location: '/admin')
  end

  private
    def queued_user_params
      params.require(:id)
    end
end
