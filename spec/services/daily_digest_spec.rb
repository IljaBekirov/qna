require 'rails_helper'

RSpec.describe DailyDigest do
  let!(:users) { create_list(:user, 3) }
  let!(:yesterday_questions) { create_list(:question, 2, created_at: Date.yesterday, user: users.first) }

  it 'sends daily digest to all users' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original }
    DailyDigest.call
  end
end
