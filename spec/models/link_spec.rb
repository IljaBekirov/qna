require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:question) { create(:question) }
  let(:link) { create(:link, linkable: question) }
  let(:bad_link) { create(:link, :bad_link, linkable: question) }

  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it 'return true if link include gist.github' do
    expect(link.gist?).to eq true
  end

  it 'return false if link not include gist.github' do
    expect(bad_link.gist?).to eq false
  end
end
