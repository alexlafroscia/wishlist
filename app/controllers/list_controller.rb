class ListController < JSONAPI::ResourceController
  before_action :verify_ownership, only: [:update, :destroy]

  private

    def verify_ownership
      current_user = context[:current_user]
      id = params[:id]
      list = List.find(id)

      unless current_user.accessible_lists.include?(list)
        raise ActiveRecord::RecordNotFound
      end

      unless current_user == list.owner
        raise NotAuthorizedError
      end
    end
end
