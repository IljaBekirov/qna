class Answer < ApplicationRecord
  validates :body, :correct, :question_id, presence: true
end
