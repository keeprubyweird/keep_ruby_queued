module QueuedUsersHelper
  def queued_user_path(user = nil)
    if user
      super id: user.id, confirm_token: user.confirm_token
    else
      super
    end
  end

  def queued_user_url(user = nil)
    if user
      super id: user.id, confirm_token: user.confirm_token
    else
      super
    end
  end
end
