FactoryBot.define do
  factory :answer do
    body { 'Body of answer' }

    trait :invalid do
      body { nil }
    end
  end
end
