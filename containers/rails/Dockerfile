FROM ruby:2.7.4

#apt-keyとdevconfのエラー対策
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV DEBCONF_NOWARNINGS=yes

ARG APP_ROOT
ARG UID
ARG GID

# node.jsと必要なライブラリのインストトール
RUN apt-get update -qq && apt-get install -y curl wget nodejs postgresql-client \
            curl apt-transport-https wget

# yarnのインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update && apt-get install -y yarn

#aptキャッシュの削除
RUN rm -rf /var/lib/apt/lists/*

RUN groupadd -g $GID intern && \
    useradd -m -s /bin/bash -u $UID -g $GID intern && \
    mkdir -p -m 777 $APP_ROOT

USER intern

WORKDIR $APP_ROOT

COPY --chown=intern:intern Gemfile* package.json yarn.lock $APP_ROOT/

RUN bundle install

RUN yarn install --frozen-lockfile

COPY --chown=intern:intern . $APP_ROOT/

EXPOSE 3000
