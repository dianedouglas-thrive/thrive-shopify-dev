FROM ruby:2.7.1-slim

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

# Install gems, yarn install, assets:precompile
RUN bundle install --without test doc \
	&& yarn install --check-files

RUN rails assets:precompile

EXPOSE 3000

# Start the application server
CMD ["bash", "-c", "bundle exec puma -C config/puma.rb"]

