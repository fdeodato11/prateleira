require "faker"
require "open-uri"

puts "Creating admin user..."
User.create!(
  email_address: "admin@prateleira.com",
  password: "password123",
  admin: true
)

puts "Creating categories..."
categories = %w[Eletrônicos Livros Roupas Casa Esportes Brinquedos Alimentos Ferramentas]

categories.each do |name|
  Category.create!(
    name: name,
    slug: name.parameterize,
    description: Faker::Lorem.paragraph(sentence_count: 2)
  )
end

puts "Creating products with images..."
categories = Category.all
statuses = Product.statuses.keys

50.times do |i|
  product = Product.new(
    category: categories.sample,
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 4),
    price: Faker::Commerce.price(range: 1.99..999.99),
    stock_quantity: Faker::Number.between(from: 0, to: 200),
    sku: "SKU-#{Faker::Alphanumeric.alpha(number: 8).upcase}",
    status: statuses.sample,
    featured: [true, false].sample,
    weight: Faker::Number.between(from: 50, to: 5000)
  )

  product.save!

  url = URI.parse("https://picsum.photos/seed/#{i + 1}/400/400")
  file = url.open
  product.image.attach(
    io: file,
    filename: "product_#{i + 1}.jpg",
    content_type: "image/jpeg"
  )
end

puts "Done! Created:"
puts "  #{User.count} admin user"
puts "  #{Category.count} categories"
puts "  #{Product.count} products"
puts "  #{ActiveStorage::Attachment.count} image attachments"
