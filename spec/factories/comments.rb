FactoryBot.define do
  factory :comment do
    user
    parent_id { nil }
    content { "MyText" }

    trait :invalid do
      content { '' }
    end
  end
end
