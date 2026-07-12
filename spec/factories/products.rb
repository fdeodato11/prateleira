FactoryBot.define do
  factory :product do
    category
    sequence(:name) { |n| "Product #{n}" }
    description { Faker::Lorem.paragraph(sentence_count: 4) }
    price { Faker::Commerce.price(range: 1.99..999.99) }
    stock_quantity { Faker::Number.between(from: 0, to: 200) }
    sequence(:sku) { |n| "SKU-#{n.to_s.rjust(6, '0')}" }
    status { :active }
    featured { false }
    weight { Faker::Number.between(from: 50, to: 5000) }

    trait :discarded do
      discarded_at { Time.current }
    end

    trait :draft do
      status { :draft }
    end

    trait :inactive do
      status { :inactive }
    end

    trait :archived do
      status { :archived }
    end

    trait :featured do
      featured { true }
    end
  end
end
