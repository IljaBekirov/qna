class AddUserToQuestionsNAnswers < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :user, foreign_key: true, null: false
    add_reference :answers, :user, foreign_key: true, null: false
  end
end
