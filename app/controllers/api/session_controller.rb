class Api::SessionController < ApplicationController
  include Authentication
  skip_authentication only: [:create]

  def create
    @token = User.authenticate(params[:email], params[:password])
    if @token.nil?
      render json: {}, status: 401
    else
      render json: { authToken: @token.value }
    end
  end

  # Public: Return the current user
  #
  # Doesn't need to handle cases where the current user might not be set,
  # because that is handled inside the authentication logic itself
  #
  # Returns: nothing.
  def get
    render json: serialize_user(@current_user)
  end

  def destroy
    token_value = @authentication[:current_token_value]
    token = AuthToken.find_by_value(token_value)
    token.destroy!
    render json: {}, status: 200
  end

  private

    def serialize_user(user)
      resource = UserResource.new(user, nil)
      JSONAPI::ResourceSerializer.new(UserResource).serialize_to_hash(resource)
    end
end
