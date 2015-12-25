require 'securerandom'

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

class User < ActiveRecord::Base
  before_save { email.downcase! }

  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password

  before_create :set_auth_token

  has_many :lists, dependent: :destroy,
                   foreign_key: 'owner_id',
                   inverse_of: :owner

  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_lists, through: :subscriptions,
                              source: :list

  # Public: Authenticate a user
  #
  # Examples:
  #
  #   user = User.authenticate('user@example.com', 'foobar')
  #
  # email - The email address for the user
  # password - The password for the user
  #
  # Returns: The user, if the credentials were correct.
  def self.authenticate(email, password)
    user = find_by_email(email)
    return user if user && user.authenticate(password)
  end

  # Public: Generate a new auth token for the user
  #
  # Returns: The new auth token.
  def regenerate_auth_token
    self.auth_token = generate_auth_token
    auth_token
  end

  # Public: Return the lists that are accessible to the user
  #
  # Returns: Array of lists
  def accessible_lists
    list_copy = lists.clone
    list_copy.concat subscribed_lists
    list_copy
  end

  private

    def set_auth_token
      return if auth_token.present?
      self.auth_token = generate_auth_token
    end

    def generate_auth_token
      SecureRandom.uuid.gsub(/\-/, '')
    end
end
