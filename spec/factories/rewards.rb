FactoryBot.define do
  factory :reward do
    question
    user
    title { 'Best answer' }
    image do
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.jpg'), 'image/jpeg')
    end
  end
end
