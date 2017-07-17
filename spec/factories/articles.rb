FactoryGirl.define do
  factory :article do
    sequence(:title) { |n| "Hello Article #{n}" }
    text 'This is demo article text'
    user_id 1

    trait :with_comments do
      after(:create) { |article| create_list(:comment, 2, article: article) }
    end
  end
end
