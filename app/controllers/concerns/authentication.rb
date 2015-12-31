module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
  end

  class_methods do
    # Public: Specify actions that do not require authentication
    #
    # Examples:
    #
    #   class SomeController < ApplicationController
    #     skip_authentication only: [:new, :create]
    #   end
    #
    #   class SomeController < ApplicationController
    #     skip_authentication except: [:index]
    #   end
    #
    # Returns nothing.
    def skip_authentication(options = {})
      skip_before_action :require_authentication, options.slice(:only, :except)
    end
  end

  # Get the currently logged-in user from the authentication token header
  def current_user
    @current_user ||= authenticate_with_http_token do |token|
      user = User.find_by_token(token)
      unless user.nil?
        @authentication ||= {}
        @authentication[:current_token_value] = token
      end
      user
    end
  end

  private

    # Require that there is a logged-in user
    def require_authentication
      unless current_user
        respond_to do |format|
          format.any { head :unauthorized }
        end
      end
    end
end
