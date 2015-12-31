class UsersController < JSONAPI::ResourceController
  skip_authentication only: [:create]
end
