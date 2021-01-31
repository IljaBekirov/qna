FactoryBot.define do
  factory :answer do
    body { 'Body of answer' }
    user
    question

    trait :invalid do
      body { nil }
    end
  end
end
