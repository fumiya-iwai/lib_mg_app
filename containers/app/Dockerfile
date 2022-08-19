FROM ruby:2.7.4

#apt-keyとdevconfのエラー対策
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV DEBCONF_NOWARNINGS=yes

# node.jsと必要なライブラリのインストトール
RUN apt-get update -qq && apt-get install -y curl wget nodejs postgresql-client \
            curl apt-transport-https wget

# yarnのインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update && apt-get install -y yarn

#aptキャッシュの削除
RUN rm -rf /var/lib/apt/lists/*

# ディレクトリ・ファイルの作成
RUN mkdir /intern-2022
WORKDIR /intern-2022
COPY Gemfile /intern-2022/Gemfile
COPY Gemfile.lock /intern-2022/Gemfile.lock

# gem(Rails6)のインストール
RUN bundle install
COPY . /intern-2022

RUN yarn install --check-files

# コンテナ起動時に毎回実行するスクリプトを追加
COPY containers/app/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# rails起動コマンド
CMD ["rails", "server", "-b", "0.0.0.0"]
