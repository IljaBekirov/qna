class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  default_scope -> { order(created_at: :desc) }

  validates :title, :body, presence: true

  def mark_as_best(answer)
    update(best_answer: answer)
    reward.update!(user: answer.user)
  end

  def other_answers
    answers.where.not(id: best_answer)
  end
end
