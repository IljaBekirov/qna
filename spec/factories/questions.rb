FactoryBot.define do
  factory :question do
    title { "Title of question" }
    body { "Body of question" }
    user
    best_answer_id { nil }

    trait :invalid do
      title { nil }
    end
  end
end
