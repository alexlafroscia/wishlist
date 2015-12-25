class NotAuthorizedError < JSONAPI::Exceptions::Error
  def errors
    [JSONAPI::Error.new(code: JSONAPI::FORBIDDEN,
                        status: :forbidden,
                        title: 'Not Authorized',
                        detail: 'User is not allowed to access this resource')
    ]
  end
end

JSONAPI.configure do |config|
  config.exception_class_whitelist = [NotAuthorizedError]
  config.use_text_errors = true
end

JSONAPI::ResourceController.class_eval do
  include Authentication

  rescue_from NotAuthorizedError, with: :reject_forbidden_request
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def reject_forbidden_request
    render json: { error: 'Forbidden' }, status: :forbidden
  end

  def record_not_found
    render json: { error: 'Not Found' }, status: :not_found
  end

  def context
    { current_user: @current_user }
  end
end
