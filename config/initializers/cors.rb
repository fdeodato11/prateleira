Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch("CORS_ORIGINS", "*")

    resource "/assets/*",
      headers: :any,
      methods: [:get, :options]

    resource "/images/**",
      headers: :any,
      methods: [:get, :options]
  end
end
