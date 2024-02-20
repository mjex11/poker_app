# ビルドステージ
FROM ruby:3 AS builder

WORKDIR /app

ENV RAILS_ENV=production
ENV NODE_ENV=production

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install --no-install-recommends -y nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq && apt-get install --no-install-recommends -y yarn

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler:2.4.12 \
    && bundle config set deployment 'true' \
    && bundle config set without 'test development' \
    && bundle install --jobs $(getconf _NPROCESSORS_ONLN) \
    && rm -rf /usr/local/bundle/cache/*.gem

COPY . /app

RUN bundle exec rails assets:precompile \
    && yarn cache clean

# 本番ステージ
FROM ruby:3

ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y tini

# railsユーザーを作成
# --home-dir homeディレクトリを指定
# --create-home homeディレクトリがなければ作成
# --user-group 同名（rails）グループを作成
# --shell ログインシェルをbashに指定
ARG HOME_DIR=/home/rails
RUN useradd --home-dir ${HOME_DIR} --create-home --user-group --shell /bin/bash rails
WORKDIR ${HOME_DIR}

COPY --chown=rails:rails --from=builder /usr/local/bundle /usr/local/bundle 
COPY --chown=rails:rails --from=builder /app /home/rails

USER rails

EXPOSE 3000

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
