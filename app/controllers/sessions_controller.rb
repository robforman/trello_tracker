class SessionsController < ApplicationController
  def create
    user = User.where(member_id: auth_hash.uid).first_or_initialize
    user.username = auth_hash.info.nickname
    user.full_name = auth_hash.info.name
    user.url = auth_hash.info.urls.profile
    user.oauth_token = auth_hash.credentials.token
    user.oauth_token_secret = auth_hash.credentials.secret
    user.save!

    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end