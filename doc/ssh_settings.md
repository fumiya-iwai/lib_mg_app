# PC ⇄ GitHubのSSH設定

## 1. gitのインストール
- https://gitfrowindows.org にアクセスし、「Download」をクリックする。
- ダウンロードしたファイルを実行し、インストーラを起動する。(すべてデフォルトの設定でよい。)

## 2. gitの設定
- ターミナルを開いて、以下のコマンドによりユーザー名とメールアドレスを設定する。
```
git config --global user.name "<ユーザー名>"
git config --global user.email "<メールアドレス>" 
```

- Windowsの場合は以下のコマンドにより、git clone時の改行コードの設定もしておく。
```
git config --global core.autocrlf input
```

## 3. 秘密鍵と公開鍵を作成する
- コマンドプロンプトを開いて、ユーザーのホームディレクトリで以下のコマンドを実行する。
```
mkdir .ssh #すでに存在していれば不要
cd .ssh
ssh-keygen -f <キーの名前(任意)> -C "<コメント(任意)>"
```

（以下、キーの名前をintern_key、コメントをinternで作成した場合で記載）

- keyを作成するか確認されるので、Enter
- パスフレーズを２回入力する。（パスフレーズはgit clone時に必要なので覚えておくこと）
- 以下の2つのファイルが作成される。
  - intern_key
  - intern_key.pub
- intern_key.pubの中身をすべてコピーする。
- .sshディレクトリの直下にconfigを作成し、以下のとおり記載する。
```
Host gitub.com
  User git
  IdentityFile ~/.ssh/intern_key
```

## 4. GitHubの設定
- GitHubにログインし、右上のメニューから「Settings」をクリックする。
- 左のメニューから「SSH and GPG keys」をクリックする。
- 右上の「New SSH Key」ボタンをクリックする。
- Title(任意)とKey(コピーしたintern_key.pubをペースト)を入力して、「Add SSH key」をクリックする。
