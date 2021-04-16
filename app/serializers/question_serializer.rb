class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :best_answer_id

  has_many :answers
  belongs_to :user

  def short_title
    object.title.truncate(7)
  end
end
