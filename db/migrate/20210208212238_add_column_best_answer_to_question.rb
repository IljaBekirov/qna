class AddColumnBestAnswerToQuestion < ActiveRecord::Migration[6.1]
  def change
    change_table :questions do |t|
      t.references :best_answer, foreign_key: { to_table: :answers }
    end
  end
end
