class Subscription < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  belongs_to :list
  validates :list, presence: true

  validate :user_doesnt_own_list

  private

    def user_doesnt_own_list
      if user && list && user == list.owner
        errors[:base] << "Can't subscribe a user to a list they own"
      end
    end
end
