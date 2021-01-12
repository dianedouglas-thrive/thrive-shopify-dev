FROM ruby:2.5

# Copy application code
COPY . /app
# Change to the application's directory
WORKDIR /app

# Install gems
# RUN bundle install --deployment --without development test
RUN bundle install

# Set Rails environment to production
ENV SHOPIFY_API_KEY b457aa4446d97a9f394f4ec99cdb7981
ENV SHOPIFY_API_SECRET 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
ENV RAILS_ENV development

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn
RUN yarn install --check-files

EXPOSE 3000

# Start the application server
# ENTRYPOINT ['rails', 's']
# ENTRYPOINT ["rails s"]
CMD ["rails", "server", "-b", "0.0.0.0"]

