class Api::AuthController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def facebook
    user = User.from_oauth(:facebook, user_params)
    render json: { oauth_token: user.oauth_token }
  end

  private

  def user_params
    params.required(:user).permit(:email, :name, :oauth_token, { oauth_identities: [:uid, :access_token] })
  end
end