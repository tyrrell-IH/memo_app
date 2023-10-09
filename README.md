# メモアプリの使用方法
## 開発環境
- macOS Sonoma ver.14.0
- Ruby 3.1.4
- Sinatra 3.1.0
- Webrick 1.8.1

これらの環境下以外での動作確認を行なっておりません。

## メモアプリのインストール方法
### git clone
任意のディレクトリ上で
```
git clone https://github.com/tyrrell-IH/memo_app.git
```
を実行します
### bundler
bundlerのインストールが必要になります。ターミナル上で
```
bundle -v
```
を実行し、bundlerがインストールされているか確認してください。
インストールされていない場合は
```
gem install bundler
```
でbundlerをインストールしてください
### bundle init
任意のディレクトリ上（上記git cloneでメモアプリをダウンロードしたホームディレクトリ上）で
```
bundle init
```
を実行してください。`bundle init`後に`Gemfile`が作成されるので、`Gemfile` 内に
```
gem 'sinatra'
gem 'webrick'
```
を追記してください。
追記後
```
bundle install
```
を実行してください。
## メモアプリを使用する
### メモアプリの起動
```
bundle exec ruby memo.rb
```
を実行してください。
実行後
http://localhost:4567/memos
へアクセスするとメモアプリが使用できます。
