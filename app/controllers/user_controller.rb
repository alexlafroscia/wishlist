class UserController < JSONAPI::ResourceController
  skip_authentication only: [:create]
end
