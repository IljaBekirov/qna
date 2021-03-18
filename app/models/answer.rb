class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  default_scope -> { order(created_at: :desc) }

  validates :body, presence: true
end
