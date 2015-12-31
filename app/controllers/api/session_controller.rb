class Api::SessionController < ApplicationController
  include Authentication
  skip_authentication only: [:create]

  def create
    user = User.authenticate(params[:email], params[:password])
    if user.nil?
      render json: {}, status: 401
    else
      render json: user
    end
  end

  def get
    render json: @current_user
  end

  def destroy
    @current_user.regenerate_auth_token
    @current_user.save!
    render json: {}, status: 200
  end
end
