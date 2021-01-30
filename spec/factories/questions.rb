FactoryBot.define do
  factory :question do
    title { "Title of question" }
    body { "Body of question" }
    user

    trait :invalid do
      title { nil }
    end
  end
end
