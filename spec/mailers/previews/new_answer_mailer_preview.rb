# Preview all emails at http://localhost:3000/rails/mailers/new_answer_mailer
class NewAnswerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer_mailer/new_notification
  def new_notification
    NewAnswerMailer.new_notification(User.first, Answer.first)
  end
end
