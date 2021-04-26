require 'rails_helper'

RSpec.describe NewAnswerNotification do
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, user: users.first) }
  let(:answer) { create(:answer, question: question) }

  it 'sends notification about new answer' do
    Subscription.find_each do |subscription|
      expect(NewAnswerMailer).to receive(:new_notification).with(subscription.user, answer).and_call_original
    end

    NewAnswerNotification.call(answer)
  end

  context 'unsubscribed user' do
    let(:user) { create(:user) }

    it 'does not notification about new answer' do
      NewAnswerNotification.call(answer)
      expect(NewAnswerMailer).to_not receive(:new_notification).with(user, answer).and_call_original
    end
  end
end
