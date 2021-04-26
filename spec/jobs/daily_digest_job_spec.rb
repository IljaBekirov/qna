require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  it 'calls DailyDigest#call' do
    expect(DailyDigest).to receive(:call)
    DailyDigestJob.perform_now
  end
end
