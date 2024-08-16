# Define Ruby version as a build argument
ARG RUBY_VERSION=3.3.4

# Base image
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Set working directory for Rails application
WORKDIR /rails

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    yarn \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client \
    git \
    pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Set production environment
ENV RAILS_ENV="development" \
    BUNDLE_WITHOUT=""

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ \
    /usr/local/bundle/cache \
    /usr/local/bundle/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
# RUN bundle exec bootsnap precompile app/ lib/

# Adjust binfiles to be executable on Linux
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# Final stage for app image
FROM base

# Copy built artifacts and application code from the build stage
COPY --from=base /usr/local/bundle /usr/local/bundle
COPY --from=base /rails /rails



# Run as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails/db /rails/log /rails/storage /rails/tmp
USER 1000:1000

# Entrypoint and default command
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD rake db:create db:migrate && \
    bundle exec rails s -p 3000 -b '0.0.0.0'
