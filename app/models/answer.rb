class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  default_scope -> { order(created_at: :desc) }

  validates :body, presence: true

  after_create :email_notification

  private

  def email_notification
    NewAnswerNotificationJob.perform_later(self)
  end
end
