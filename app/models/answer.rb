class Answer < ApplicationRecord
  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  default_scope -> { order(created_at: :desc) }

  validates :body, presence: true
end
