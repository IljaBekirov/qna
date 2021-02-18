FactoryBot.define do
  factory :link do
    name { 'MyString' }
    url { 'https://gist.github.com/IljaBekirov/5baa801d531d14eeb2044328caa7f918' }

    trait :bad_link do
      name { 'BadLink' }
      url { 'https://gist.other-url.com' }
    end
  end
end
