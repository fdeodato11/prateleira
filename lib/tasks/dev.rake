namespace :dev do
  desc "Attach sample images to products"
  task attach_images: :environment do
    require "open-uri"

    puts "Downloading sample images..."
    products = Product.kept.where.missing(:image_attachment)

    if products.none?
      puts "All products already have images."
      next
    end

    10.times do |i|
      url = URI.parse("https://picsum.photos/seed/#{i + 1}/400/400")
      file = url.open
      filename = "product_#{i + 1}.jpg"
      tempfile = Tempfile.new(["image", ".jpg"])
      tempfile.binmode
      tempfile.write(file.read)
      tempfile.rewind

      products.sample.image.attach(
        io: tempfile,
        filename: filename,
        content_type: "image/jpeg"
      )

      tempfile.close
    end

    puts "Attached images to #{products.count} products."
  end
end
