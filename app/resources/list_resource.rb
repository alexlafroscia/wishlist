class ListResource < JSONAPI::Resource
  attribute :title

  has_one :owner

  def self.records(options = {})
    context = options[:context]
    current_user = context[:current_user]
    current_user.accessible_lists
  end
end
