# config/initializers/sidekiq.rb

require "sidekiq"

Sidekiq.configure_server do |config|
  # Configure Sidekiq server to use Redis
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://redis:6379/1") }
end

Sidekiq.configure_client do |config|
  # Configure Sidekiq client to use Redis
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://redis:6379/1") }
end
