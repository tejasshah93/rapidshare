# Class User
class User < ActiveRecord::Base
  # has_secure_password
  has_many :documents
  attr_accessor :password
  before_save :encrypt_password

  validates_presence_of :password, on: :create
  validates_presence_of :email
  validates_uniqueness_of :email

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  # rubocop:disable LineLength
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    end
  end
end
