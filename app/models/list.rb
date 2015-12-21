class List < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :owner, foreign_key: 'user_id', class_name: 'User'
  validates :owner, presence: true
end
