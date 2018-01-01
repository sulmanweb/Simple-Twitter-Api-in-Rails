class User < ApplicationRecord
  has_secure_password

  ## VALIDATIONS
  # username must exist and unique with regex format
  validates :username, presence: true, uniqueness: true, format: {with: /\A(\w){1,15}\z/}
  # email must exist and unique with regex format
  validates :email, presence: true, uniqueness: true, format: {with: /\A(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))\z/}
  # validates password length and regex
  validates :password, presence: true, on: :create
  validates :password, length: {in: PASSWORD_LENGTH_MIN..PASSWORD_LENGTH_MAX}, format: {with: /\A(?=.*[0-9])(?=.*[!@#\$%\^&\*])/}, if: :password

end
