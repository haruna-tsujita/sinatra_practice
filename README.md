Sinatra_practice

リポジトリ（Webアプリ）の名前：Name
Sinatra＿practice　メモアプリ

概要：Overview
メモをタイトルと本文に分けて登録・更新・削除することができる。

使い方：Usage
 PostgreSQLでデータベースにテーブルを作成する
1. PostgreSQLをインストールし、起動する
2. 以下のようにデータベースとテーブルを作成する
3. CREATE DATABASE memo_data;
4. CREATE TABLE memo_data
	(id text not null,
	title text,
	content text);

Sinatraを使う準備をする
1. 下記の環境に記した、ruby,sinatra,sinatra-contrib,pg,bundlerをインストールする
2. $ git clone https://github.com/napple29/sinatra_practice.git
3. $ cd sinatra_practice
4. $ bundle install
5. $ bundle exec ruby memo.rb
6. http://localhost:4567/memo にアクセス

環境：Requirement
ruby 2.7.0 
sinatra 2.1.0 
sinatra-contrib 2.1.0 
bundler 2.1.2 
pg 1.2.3
PostgreSQL 13.3

文責：Author
napple29　はるな
