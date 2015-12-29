require 'securerandom'

class AuthToken < ActiveRecord::Base
  validates :value, presence: true
  validates :user, presence: true

  before_validation :create_token

  belongs_to :user

  # Public: Regenerate the value of a token
  #
  # Returns: The new auth token.
  def regenerate_token
    self.value = generate_auth_token
  end

  private

    def create_token
      regenerate_token unless value.present?
    end

    def generate_auth_token
      SecureRandom.uuid.gsub(/\-/, '')
    end
end
