FactoryBot.define do
  factory :question do
    title { 'Title of question' }
    body { 'Body of question' }
    user
    best_answer_id { nil }

    trait :invalid do
      title { nil }
    end

    trait :created_at_yesterday do
      created_at { Date.yesterday }
    end

    trait :created_at_more_yesterday do
      created_at { Date.today - 2 }
    end
  end
end
