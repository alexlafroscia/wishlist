VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

class User < ActiveRecord::Base
  before_save { email.downcase! }

  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password

  has_many :lists, dependent: :destroy,
                   foreign_key: 'owner_id',
                   inverse_of: :owner

  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_lists, through: :subscriptions,
                              source: :list

  has_many :auth_tokens, dependent: :destroy

  # Public: Authenticate a user
  #
  # Given a user's email address and password, authenticate a user and generate
  # a new authentication token for their session
  #
  # Examples:
  #
  #   token = User.authenticate('user@example.com', 'foobar')
  #   token.value # => 'sadioasdfjqesdfklj2319adfjk....'
  #
  # email - The email address for the user
  # password - The password for the user
  #
  # Returns: The auth token, if the credentials were correct.
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.authenticate(password)
      user.generate_auth_token
    end
  end

  # Public: Look up a user by an auth token
  #
  # Examples:
  #
  #   user = User.find_by_token('some-auth-token')
  #
  # token_value - The value of the auth token
  #
  # Returns; The user associated with the given token
  def self.find_by_token(token_value)
    token = AuthToken.find_by_value(token_value)
    token.user if token.present?
  end

  # Public: Return the lists that are accessible to the user
  #
  # Returns: Array of lists
  def accessible_lists
    list_copy = lists.clone
    list_copy.concat subscribed_lists
    list_copy
  end

  # Public: Make a new auth token for the user
  #
  # Returns: nothing.
  def generate_auth_token
    token = AuthToken.new(user: self)
    token if token.save
  end
end
