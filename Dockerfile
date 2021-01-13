FROM ruby:2.5

RUN mkdir /app \
    && apt-get update \
    && apt-get install -y --force-yes \
       curl apt-transport-https \
       git build-essential ruby-dev libc-dev \
       libsqlite3-dev libmariadbclient-dev-compat \
       libxml2-dev libxslt1-dev imagemagick \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs yarn

# Copy application code and change to the application's directory
COPY . /app
WORKDIR /app

# Install gems, yarn install
RUN bundle install --without test doc \
	&& yarn install --check-files

# Set ENV variables with api creds
ENV SHOPIFY_API_KEY b457aa4446d97a9f394f4ec99cdb7981
ENV SHOPIFY_API_SECRET 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

EXPOSE 3000

# Start the application server
CMD ["bash", "-c", "bundle exec puma -C config/puma.rb"]

