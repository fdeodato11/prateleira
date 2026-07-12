namespace :dev do
  desc "Attach sample images to any products missing them"
  task attach_images: :environment do
    require "open-uri"

    products = Product.where.missing(:image_attachment)

    if products.none?
      puts "All products already have images."
      next
    end

    puts "Downloading images for #{products.count} products..."
    products.each_with_index do |product, i|
      url = URI.parse("https://picsum.photos/seed/#{i + 1}/400/400")
      file = url.open
      product.image.attach(
        io: file,
        filename: "product_#{i + 1}.jpg",
        content_type: "image/jpeg"
      )
    end

    puts "Done!"
  end
end
