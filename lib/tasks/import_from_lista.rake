namespace :products do
  desc "Import products from scraped ML lista page JSON"
  task import_from_lista: :environment do
    json_path = "/tmp/ml_products.json"

    unless File.exist?(json_path)
      puts "ERROR: File not found at #{json_path}"
      exit 1
    end

    products_data = JSON.parse(File.read(json_path))

    existing_ids = Set.new
    Product.where(source: "mercadolivre").find_each do |p|
      match = p.external_url.to_s.match(%r{/p/(MLB\w+)})
      existing_ids << match[1] if match
    end

    category = Category.find_or_create_by!(name: "Geral")
    imported = 0
    skipped = 0
    errors = 0

    products_data.each do |data|
      mpid = data["product_id"]

      if existing_ids.include?(mpid)
        puts "  SKIP (already exists): #{mpid} - #{data["name"].truncate(50)}"
        skipped += 1
        next
      end

      base_url = data["url"].gsub(/\Ahttps?:\/\//, "").gsub(/[?#].*\z/, "")
      clean_url = base_url.chomp("/")
      sku = "ML_#{mpid}"

      product = Product.new(
        name: data["name"],
        sku: sku,
        price: data["price"],
        original_price: data["original_price"],
        source: "mercadolivre",
        external_url: clean_url,
        rating: data["rating"],
        reviews_count: data["reviews"],
        status: :active,
        category: category
      )

      if product.save
        if data["image"].present?
          begin
            downloaded = URI.open(data["image"])
            product.image.attach(
              io: downloaded,
              filename: "#{mpid}.jpg",
              content_type: "image/jpeg"
            )
            downloaded.close
          rescue StandardError => e
            puts "  WARN: Failed to download image for #{mpid}: #{e.message}"
          end
        end
        imported += 1
      else
        puts "  ERROR: #{product.errors.full_messages.join(", ")} - #{data["name"].truncate(50)}"
        errors += 1
      end
    end

    puts ""
    puts "=== SUMMARY ==="
    puts "Total in file: #{products_data.size}"
    puts "Imported: #{imported}"
    puts "Skipped (duplicate): #{skipped}"
    puts "Errors: #{errors}"
    puts "Total ML products now: #{Product.where(source: 'mercadolivre').count}"
  end

  desc "Retry downloading images for ML products without images"
  task retry_ml_images: :environment do
    require "open-uri"

    products = Product.where(source: "mercadolivre")
    total = products.count
    fixed = 0
    skipped = 0

    products.find_each.with_index do |product, idx|
      if product.image.attached?
        skipped += 1
        next
      end

      mpid = product.external_url.to_s.match(%r{/p/(MLB\w+)})&.[](1)
      unless mpid
        puts "  SKIP #{product.sku}: no MLB ID in URL"
        skipped += 1
        next
      end

      # Try to find the image URL from the JSON file
      json_data = JSON.parse(File.read("/tmp/ml_products.json"))
      entry = json_data.find { |d| d["product_id"] == mpid }
      unless entry && entry["image"]
        puts "  SKIP #{mpid}: no image data in JSON"
        skipped += 1
        next
      end

      begin
        downloaded = URI.open(entry["image"])
        product.image.attach(
          io: downloaded,
          filename: "#{mpid}.jpg",
          content_type: "image/jpeg"
        )
        downloaded.close
        fixed += 1
        puts "  #{idx + 1}/#{total} OK: #{mpid}"
      rescue StandardError => e
        puts "  #{idx + 1}/#{total} FAIL #{mpid}: #{e.message}"
      end
    end

    puts ""
    puts "=== SUMMARY ==="
    puts "Total ML products: #{total}"
    puts "Already had image: #{skipped}"
    puts "Images downloaded now: #{fixed}"
    puts "Without image: #{Product.where(source: 'mercadolivre').where.missing(:image_attachment).count}"
  end
end
