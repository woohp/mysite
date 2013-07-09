class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :todos

  validates :username, length: { minimum: 5 }, uniqueness: true
  validates :password, length: { minimum: 3 }, if: :password
  validates :password, confirmation: true, if: :password
end
