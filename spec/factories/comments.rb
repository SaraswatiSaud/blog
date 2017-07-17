FactoryGirl.define do
  factory :comment do
    commenter 'Pintoo'
    body 'This is comment body.'
    article
  end
end
