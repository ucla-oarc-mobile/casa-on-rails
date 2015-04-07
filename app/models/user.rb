class User < ActiveRecord::Base

  attr_accessor :password

  has_one :oauth2_identity

  before_save do
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  class << self

    def find_by_credentials credentials

      return nil unless credentials.include?(:username) and credentials.include?(:password)

      user = find_by_username credentials[:username]

      if user and user.password_hash == BCrypt::Engine.hash_secret(credentials[:password], user.password_salt)
        user
      else
        nil
      end

    end

  end

end
