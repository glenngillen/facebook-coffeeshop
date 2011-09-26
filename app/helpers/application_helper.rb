module ApplicationHelper
  def facebook_profile_img_url(user_id)
    "https://graph.facebook.com/#{user_id}/picture?type=square"
  end

  def current_user
    @current_user
  end
end
