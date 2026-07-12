Rails.application.config.active_storage.variant_processors = :vips

Rails.application.config.active_storage.track_variants = true

Rails.application.config.active_storage.content_types_to_serve_as_binary -= %w[
  image/jpeg
  image/png
  image/webp
]
