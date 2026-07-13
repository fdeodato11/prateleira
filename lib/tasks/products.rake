namespace :products do
  desc "Import products from Mercado Livre via the scraper API"
  task import_from_mercadolivre: :environment do
    api_url = ENV.fetch("SCRAPPER_API_URL", "http://localhost:4567")

    puts "Fetching products from Mercado Livre via #{api_url}..."
    result = Products::ImportFromMercadoLivre.new(api_url: api_url).call

    puts ""
    puts "=== Import Summary ==="
    puts "  Created: #{result[:created]}"
    puts "  Updated: #{result[:updated]}"
    puts "  Failed:  #{result[:failed]}"
    puts "  Total:   #{result[:total]}"

    if result[:errors].any?
      puts ""
      puts "=== Errors ==="
      result[:errors].each { |err| puts "  - #{err}" }
    end
  end
end
