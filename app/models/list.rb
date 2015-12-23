class List < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :owner, foreign_key: 'owner_id',
                     class_name: 'User',
                     inverse_of: :lists
  validates :owner, presence: true

  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions,
                         source: :user
end
