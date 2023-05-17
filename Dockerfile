FROM ruby:3.2.2

WORKDIR /app

ENV RAILS_ENV=production
ENV NODE_ENV=production

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential \
    tini \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install --no-install-recommends -y nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq && apt-get install --no-install-recommends -y yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler:2.4.12 \
    && bundle config set deployment 'true' \
    && bundle config set without 'test development' \
    && bundle install --jobs $(getconf _NPROCESSORS_ONLN) \
    && rm -rf /usr/local/bundle/cache/*.gem

COPY . /app

RUN bundle exec rails assets:precompile \
    && yarn cache clean \
    && rm -rf node_modules tmp/cache

EXPOSE 3000

ENV RAILS_SERVE_STATIC_FILES=true
ENV SECRET_KEY_BASE foo

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
