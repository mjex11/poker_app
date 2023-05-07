FROM ruby:2.7.7-alpine

WORKDIR /app

ENV RAILS_ENV=production
ENV NODE_ENV=production

# 依存パッケージのインストール
COPY Gemfile Gemfile.lock /app/
RUN apk add --no-cache -t .build-dependencies \
    build-base \
    libxml2-dev\
    libxslt-dev \
    && apk add --no-cache \
    bash \
    file \
    imagemagick \
    libpq \
    libxml2 \
    libxslt \
    nodejs \
    postgresql-dev \
    tini \
    tzdata \
    yarn \
    gcompat \
    && gem install bundler:2.1.4 \
    && bundle install -j$(getconf _NPROCESSORS_ONLN) --deployment --without test development \
    && apk del --purge .build-dependencies

# アプリケーションコードのコピー
COPY . /app

# アセットのプリコンパイル
RUN bundle exec rails assets:precompile \
    && yarn cache clean \
    && rm -rf node_modules tmp/cache

# ランタイム設定
ENV RAILS_SERVE_STATIC_FILES=true
ENV SECRET_KEY_BASE foo
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
EXPOSE 3000
