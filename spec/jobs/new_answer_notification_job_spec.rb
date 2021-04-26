require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:question) { create(:question) }

  it 'calls NewAnswerNotification#call' do
    expect(NewAnswerNotification).to receive(:call)
    NewAnswerNotificationJob.perform_now(question)
  end
end
