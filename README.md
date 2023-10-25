# メモアプリの使用方法
## 開発環境
- macOS Sonoma ver.14.0
- Ruby 3.1.4
- Sinatra 3.1.0
- Webrick 1.8.1
- PostgreSQL 15.3

これらの環境下以外での動作確認を行なっておりませんので、できるだけ近しい環境下でメモアプリをご利用ください。

## メモアプリのインストール方法
### git clone
任意のディレクトリ上で
```
git clone https://github.com/tyrrell-IH/memo_app.git
```
を実行します。

インストールが成功すると`memo_app`ディレクトリが作成されるので`memo_app`ディレクトリへ移動します。

**注意**
現在mainブランチにdb_devブランチ（DB開発ブランチ）がマージされていない状態なので、上記git cloneの実行のみでは不完全な状態でのインストールになります。
```
git checkout -b db_dev origin/db_dev
```
を実行しdevブランチを取り込む必要があります。

## データベースを用意する
### PostgreSQLのインストール
このメモアプリではデータベース(関係データベース管理システム)として`PostgreSQL`を使用します。
参考リンク等を参照しながらインストールしてください。

参考：[ダウンロード \| 日本PostgreSQLユーザ会](https://www.postgresql.jp/download)

### データベースの作成
PostgreSQL上に`memo`という名称のデータベースを作成します。PostgreSQLにログイン後以下のSQL文を実行してください
```sql
CREATE DATABASE memo;
```
### テーブルの作成
PostgreSQLにログインした状態で
`\c memo`
を実行、データベース`memo`を選択した後以下を実行し`Memos`という名称のテーブルを作成します。
```sql
CREATE TABLE Memos
(id serial NOT NULL,
title VARCHAR(20) NOT NULL,
text VARCHAR(120),
PRIMARY KEY (id));
```
これでデータベース、テーブルの作成は終了ですので、`\q`でPostgreSQLを終了して構いません。

## bundler
### bundleのインストール
このメモアプリでは各Gemの依存関係の解決のためBundlerを使用します。
ターミナル上で
```
bundle -v
```
を実行し、bundlerがインストールされているか確認してください。
インストールされていない場合は
```
gem install bundler
```
でbundlerをインストールしてください
### bundle install
`memo_app`ディレクトリ上で
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
