class Todo < ActiveRecord::Base
  as_enum :status, [:pool, :finished]

  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true, unless: :description
  validates :description, presence: true, unless: :title
end
