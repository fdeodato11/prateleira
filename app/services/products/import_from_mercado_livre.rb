require "net/http"
require "json"
require "open-uri"

module Products
  class ImportFromMercadoLivre
    SCRAPPER_API_URL = ENV.fetch("SCRAPPER_API_URL", "http://localhost:4567")

    def initialize(api_url: nil)
      @api_url = api_url || SCRAPPER_API_URL
      @created = 0
      @updated = 0
      @failed = 0
      @errors = []
    end

    def call
      products_data = fetch_products
      return summary if products_data.empty?

      products_data.each do |data|
        process_product(data)
      end

      summary
    end

    private

    def fetch_products
      uri = URI("#{@api_url}/api/products?platform=mercadolivre")
      response = Net::HTTP.get_response(uri)

      unless response.is_a?(Net::HTTPOK)
        @errors << "API returned #{response.code}: #{response.message}"
        return []
      end

      json = JSON.parse(response.body)
      json["products"] || []
    rescue JSON::ParserError => e
      @errors << "Invalid JSON response: #{e.message}"
      []
    rescue Net::HTTPError, Net::OpenTimeout, Net::ReadTimeout, SocketError => e
      @errors << "Connection error: #{e.message}"
      []
    end

    def process_product(data)
      category = find_or_create_category(data["category"] || "Geral")
      return unless category

      sku = data["id"] || Products::ImportFromMercadoLivre.generate_sku(data["name"])
      product = Product.find_or_initialize_by(sku: sku)

      was_new_record = product.new_record?

      product.assign_attributes(
        category: category,
        name: data["name"],
        description: data["description"].presence || product.description.presence || data["name"],
        price: data["price"],
        original_price: data["original_price"],
        stock_quantity: data["in_stock"] != false ? 1 : 0,
        status: :active,
        source: "mercadolivre",
        external_url: data["url"],
        rating: data["rating"] || 0.0,
        reviews_count: data["reviews"] || 0,
        featured: false,
        weight: 0
      )

      product.save!
      attach_image(product, data["image"]) if data["image"].present?

      if was_new_record
        @created += 1
      else
        @updated += 1
      end
    rescue ActiveRecord::RecordInvalid => e
      @failed += 1
      @errors << "Product '#{data["name"]}': #{e.message}"
    rescue StandardError => e
      @failed += 1
      @errors << "Product '#{data["name"]}': #{e.message}"
    end

    def find_or_create_category(name)
      Category.find_or_create_by!(name: name) do |c|
        c.slug = name.parameterize
        c.description = "Categoria importada do Mercado Livre"
      end
    rescue ActiveRecord::RecordNotUnique
      Category.find_by(name: name)
    end

    def attach_image(product, image_url)
      return if image_url.blank?

      begin
        uri = URI.parse(image_url)
        uri.open(read_timeout: 10) do |file|
          filename = File.basename(uri.path)
          product.image.attach(io: file, filename: filename, content_type: file.content_type)
        end
      rescue StandardError => e
        @errors << "Image download failed for '#{product.name}': #{e.message}"
      end
    end

    def summary
      {
        created: @created,
        updated: @updated,
        failed: @failed,
        errors: @errors,
        total: @created + @updated + @failed
      }
    end

    def self.generate_sku(name)
      return "ML-#{SecureRandom.hex(4)}" if name.blank?

      base = name.downcase
                 .gsub(/[áàâãä]/, "a")
                 .gsub(/[éèêë]/, "e")
                 .gsub(/[íìîï]/, "i")
                 .gsub(/[óòôõö]/, "o")
                 .gsub(/[úùûü]/, "u")
                 .gsub(/ç/, "c")
                 .gsub(/ñ/, "n")
                 .gsub(/[^\w\s-]/, "")
                 .gsub(/\s+/, "_")
                 .gsub(/_+/, "_")
                 .gsub(/^_|_$/, "")

      "ml_#{base}_#{SecureRandom.hex(2)}"
    end
  end
end
