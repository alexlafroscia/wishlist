class UserResource < JSONAPI::Resource
  attributes :email, :name, :password

  def fetchable_fields
    super - [:password]
  end
end
