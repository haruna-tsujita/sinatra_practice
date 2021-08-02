# Sinatra_practice
リポジトリ（Webアプリ）の名前：Name
Sinatra＿practice　メモアプリ

概要：Overview
メモをタイトルと本文に分けて登録・更新・削除することができる。

使い方：Usage

1.下記の環境に記した、ruby,sinatra,sinatra-contrib,bundlerをインストールする
2.任意の名前でディレクトリを作成
3.bundle initを実行し、Gemfileを作成する
4.Gemfileに下記２行を追記する
	gem 'sinatra'
	gem 'sinatra-contrib'

5.その後bundle installを行う
6.作成したディレクトリの下に、memo.rb , public/style.cssを置く
7.作成したディレクトリの下にdataディレクトリを作成
8.作成したディレクトリ下で$ bundle exec ruby memo.rbを実行する
9.http://localhost:4567/memo にアクセス

環境：Requirement
ruby 2.7.0
sinatra 2.1.0
sinatra-contrib 2.1.0
bundler 2.1.2
json 2.3.0

文責：Author
napple29　はるな

