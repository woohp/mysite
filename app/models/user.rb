class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :username, :email, :password, :password_confirmation

  validates :password, length: { minimum: 3 }, if: :password
  validates :password, confirmation: true, if: :password
end
