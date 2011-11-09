class AuthenticationController < ApplicationController
  skip_before_filter :authenticate!
  skip_before_filter :set_app

  def login
    session[:at] = nil
    @current_user = nil
    case params[:id]
    when 'facebook'
      redirect_to authenticator.authorize_url(:scope => facebook_scope,
                                              :display => 'page')
    else
      render :status => :unauthorized
    end
  end

  def callback
    case params[:id]
    when 'facebook'
      client = Mogli::Client.create_from_code_and_authenticator(params[:code],
                                                                authenticator)
      session[:at] = client.access_token
      add_user current_user.id, current_user.name
      redirect_to '/'
    else
      render :status => :unauthorized
    end
  end

  def logout
    session[:at] = nil
    redirect_to '/'
  end
end
