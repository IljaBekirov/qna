FactoryBot.define do
  factory :comment do
    sequence :body do |n|
      "Comment body #{n}"
    end
  end
end
