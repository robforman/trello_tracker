class SessionsController < ApplicationController
  skip_before_filter :ensure_current_user, only: [:new, :create]

  def new
    redirect_to webhooks_path if current_user
  end

  def create
    user = User.where(member_id: auth_hash.uid).first_or_initialize
    user.username = auth_hash.info.nickname
    user.full_name = auth_hash.info.name
    user.url = auth_hash.info.urls.profile
    user.oauth_token = auth_hash.credentials.token
    user.oauth_token_secret = auth_hash.credentials.secret
    user.save!

    session[:user_id] = user.id
    redirect_to root_path, :notice => "Logged in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_sessions_path, :notice => "Logged out!"
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end