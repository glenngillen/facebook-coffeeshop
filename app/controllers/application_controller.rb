class ApplicationController < ActionController::Base
  @@users = []
  protect_from_forgery
  before_filter :authenticate!
  before_filter :set_app

  private
  def set_app
    return if session[:at].blank?
    @app  = Mogli::Application.find(ENV["FACEBOOK_APP_ID"], client)
  rescue Mogli::Client::HTTPException
    session[:at] = nil
    authenticate!
  end

  def redis?
    defined?(REDIS)
  end

  def add_user(id, name)
    REDIS.sadd("user", [id, name].join("||")) if redis?
  rescue Errno::ECONNREFUSED
  end

  def users
    if redis?
      REDIS.smembers("user").map do |str|
        id, name = str.split("||")
        { "id" => id, "name" => name }
      end
    else
      []
    end
  rescue Errno::ECONNREFUSED
    []
  end

  def authenticate!
    return true
    if session[:at].blank?
      redirect_to auth_path('facebook')
    else
      current_user
    end
  rescue Mogli::Client::HTTPException
    session[:at] = nil
    retry
  end

  def authenticator
    @authenticator ||= Mogli::Authenticator.new(ENV["FACEBOOK_APP_ID"],
                                                ENV["FACEBOOK_SECRET"],
                                                auth_callback_url('facebook'))
  end

  def client
    @client ||= Mogli::Client.new(session[:at])
  end

  def current_user
    @current_user ||= User.new(Mogli::User.find("me", client))
  end

  def facebook_scope
    'user_likes,user_photos,user_photo_video_tags,read_stream'
  end
end
