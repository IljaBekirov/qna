class Question < ApplicationRecord
  include Linkable

  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  default_scope -> { order(created_at: :desc) }

  validates :title, :body, presence: true

  def mark_as_best(answer)
    transaction do
      update!(best_answer: answer)
      reward.update!(user: answer.user)
    end
  end

  def other_answers
    answers.where.not(id: best_answer)
  end
end
