FactoryBot.define do
  factory :comment do
    sequence :body do |n|
      "Comment body #{n}"
    end
    user
    commentable_id { nil }
    commentable_type { nil }
  end
end
