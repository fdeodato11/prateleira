FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    sequence(:slug) { |n| "category-#{n}" }

    trait :discarded do
      discarded_at { Time.current }
    end
  end
end
