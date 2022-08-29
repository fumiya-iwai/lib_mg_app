# README

This README would normally document whatever steps are necessary to get the
application up and running.

### 0.初期設定
- slack に参加
- PC ⇄ github の ssh 設定
  - sshの設定については、intern-2022/doc/ssh_settings.md を参照

### 1. Docker Desktop を用意する
- Windowsの場合の導入方法については、intern-2022/doc/settings_for_windows.md を参照
- Macの場合は https://www.docker.com/get-started/ よりダウンロード・インストールする。

### 2. Gitリポジトリのクローン
```text
git clone git@github.com:ingage/intern-2022.git
cd intern-2022
 ```

### 3. dockerイメージをbuildする
```text
docker-compose build
```

### 4.初期データ作成(ダンプデータがない場合)

appコンテナを起動し中に入る

```shell
docker-compose run --rm rails bash
```

appコンテナ内で以下のコマンドを実行

```shell
rails db:create
rails db:schema:load
rails db:seed
exit
```

### 5.サービス立ち上げ（コンテナの作成・実行）

```shell
docker-compose up -d
```

ブラウザで動作確認、以下にアクセス

- URL: http://localhost:3000
- ID: `wada@example.com`
- Password: `ingage`

### 6.その他のコマンド

普段の作業は以下のコマンドを使うことになります。

```shell
# サービスの停止
docker-compose stop

# サービスの実行
docker-compose start

# サービスの停止と実行
docker-compose restart

# 指定したサービスの停止と実行（例:webpacker）
docker-compose restart webpacker

# Railsコンテナに入ってコマンドなどを実行 docker-compose exec app [command...]
docker-compose exec rails bin/rails c           # Railsコンソール
docker-compose exec rails bin/rails db:migrate  # db:migrate実行

# Railsコンテナを立ち上げてコマンドなどを実行 docker-compose run --rm rails [command...]
docker-compose run --rm rails bin/rails c           # Railsコンソール
docker-compose run --rm rails bin/rails db:migrate  # db:migrate実行

# 起動中のコンテナに入ってコマンドを実行したい場合
docker-compose exec rails bash

# サービス一覧
docker-compose ps

# すべてのコンテナ一覧
docker ps

# すべてのコンテナ稼働状況
docker stats

# コンテナ・ネットワークの削除
docker-compose down

# コンテナ・ネットワーク・ボリュームの削除
docker-compose down -v

# ログの表示 docker compose logs [service]
# docker-compose -f [service]はよく止まるのでおすすめできない
docker compose logs -f --tail 100 --no-log-prefix rails # railsコンテナのログ表示
# もしくは docker logs [コンテナ名]
docker logs -f -n 100 intern-2022-rails

# ログファイルを参照したい場合
docker-compose exec rails bash
tail -f -n 100 log/develop.log
# もしくは
docker-compose run --rm rails tail -f -n 100 log/develop.log
```
