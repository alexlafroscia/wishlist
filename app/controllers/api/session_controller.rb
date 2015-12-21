class Api::SessionController < ApplicationController
  include Authentication
  skip_authentication only: [:create]

  def create
    user = User.authenticate(params[:email], params[:password])
    if user.nil?
      render json: {}, status: 401
    else
      render json: { auth_token: user.auth_token }
    end
  end

  def get
    render json: serialize_user(@current_user)
  end

  def destroy
    @current_user.regenerate_auth_token
    @current_user.save!
    render json: {}, status: 200
  end

  private

    def serialize_user(user)
      resource = UserResource.new(user, nil)
      JSONAPI::ResourceSerializer.new(UserResource).serialize_to_hash(resource)
    end
end
