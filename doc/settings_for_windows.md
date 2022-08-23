# WindowsでのDocker Desktopのダウンロード

## 0. WSL2のインストール
- WSL2は、Windows 10 (バージョン 1903、ビルド 18362 以上) でのみ使用できる。
- Windows Power Shellを管理者として実行する。
- 以下のコマンドを実行する。
```
wsl --install
```

- PCを再起動する。
- 再起動するとUbuntuが自動で起動するので、自身の使用するユーザー名とパスワードを入力する。

## 1. Docker for Desktopのインストール
- https://www.docker.com/ にアクセスし、画面右上部の「Get Started」をクリックする。
- 「Download for Windows」をクリックする。
- ダウンロードしたファイルを実行し、インストーラを起動する。
- 「Use WSL2 instead of Hyper-V(recommended)」にチェックが入っていることを確認し、「OK」をクリックする。
- インストール完了後、Windowsからログアウトされるので再度ログインするとDocker利用規約への同意を求められる。「I accept the terms」にチェックをいれて、「Accept」をクリックする。
