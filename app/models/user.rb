require 'securerandom'

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

# User Model
#
# Represents a user in the system
class User < ActiveRecord::Base
  before_save { email.downcase! }

  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  before_create :set_auth_token

  def self.authenticate(email, password)
    user = find_by_email(email)
    return user if user && user.authenticate(password)
  end

  def regenerate_auth_token
    self.auth_token = generate_auth_token
    auth_token
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
