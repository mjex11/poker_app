FROM ruby:2.7.7

WORKDIR /app

ENV RAILS_ENV=production
ENV NODE_ENV=production

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential \
    nodejs \
    tini \
    yarn \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler:2.1.4 \
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
