class User < ApplicationRecord
  validates :name,  presence: true, length: {maximum: Settings.max_name_length}
  validates :email, presence: true, length: {maximum: Settings.max_email_length},
    format: {with: Settings.valid_email_regex}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.min_password_length}
end
