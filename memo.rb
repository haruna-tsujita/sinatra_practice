# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'erb'
require 'SecureRandom'

def write_memo
  @title = params[:title]
  @content = params[:content]
  memo = { 'id' => SecureRandom.uuid, 'title' => @title, 'content' => @content }
  File.open("data/memos_#{memo['id']}.json", 'w') { |file| JSON.dump(memo, file) }
end

def read_memo
  files = Dir.glob('data/*')
  @memos = files.map { |file| JSON.parse(File.read(file)) }
end

def show_memo
  @id = params[:id]
  read_memo
  @memo = @memos.find { |x| x['id'].include?(@id) }
end

def overwrite_memo
  @id = params[:id]
  @title = params[:title]
  @content = params[:content]
  memo = { 'id' => @id, 'title' => @title, 'content' => @content }
  File.open("data/memos_#{memo['id']}.json", 'w') { |file| JSON.dump(memo, file) }
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memo' do
  read_memo
  erb :memo_top
end

post '/memo' do
  write_memo
  read_memo
  redirect to('/memo')
end

get '/new_memo' do
  erb :new_memo
end

get '/memos/:id' do
  show_memo
  erb :show_memo
end

delete '/memos/:id' do
  @id = params[:id]
  File.delete("data/memos_#{@id}.json")
  redirect to('/memo')
  erb :show_memo
end

get '/memos/:id/edit' do
  show_memo
  erb :edit_memo
end

patch '/memos/:id' do
  show_memo
  overwrite_memo
  redirect to("/memos/#{@id}")
  erb :show_memo
end

__END__
@@memo_top
<!DOCTYPE html>
<html lang="ja">
<head>
  <mata charset="utf-8">
  <title>Sinatra - memo</title>
</head>
<body>
  <link rel="stylesheet" href="/style.css" />
  <h1>メモアプリ</h1>
  <ul>
    <% @memos.each do |memo| %>
      <li><a href="/memos/<%= memo["id"] %>"><%= memo["title"] %></a></li>
    <% end %>
  </ul>
  </br>
  <form method="get" action="new_memo">
    <input type="submit" value="追加" class="get">
  </form>
</body>
</html>

@@new_memo
<!DOCTYPE html>
<html lang="ja">
<head>
  <mata charset="utf-8">
  <title>Sinatra - memo</title>
</head>
<body>
  <link rel="stylesheet" href="/style.css" />
  <h1>メモアプリ</h1>
  <form method="get" action="memo">
    <input type="submit" value="メモ一覧" class="memolist">
  </form>
  <form method="post" action="memo">
    <input type="text" name="title" id="title" value="" class="title"></br>
    <textarea name="content" id="memo" value="" rows="5" class="content"></textarea></br>
    <input type="submit" value="送信" class="get">
  </form>
</body>
</html>

@@show_memo
<!DOCTYPE html>
<html lang="ja">
<head>
  <mata charset="utf-8">
  <title>Sinatra - memo</title>
</head>
<body>
  <link rel="stylesheet" href="/style.css" />
  <h1>メモアプリ</h1>
  <form method="get" action="/memo">
    <input type="submit" value="メモ一覧" class="memolist">
  </form>
  <p><%= h@memo["title"] %></p>
  <p><%= h@memo["content"] %></p>
  <table>
  <form method="get" action="/memos/<%= @memo["id"]%>/edit">
    <input type="submit" value="変更" class="get">
  </form>
  <form method="post">
    <input type="hidden" name="_method" value="delete" class="delete">
    <input type="submit" value="削除" class="delete">
  </form>
  </table>
</body>
</html>

@@edit_memo
<!DOCTYPE html>
<html lang="ja">
<head>
  <mata charset="utf-8">
  <title>Sinatra - memo</title>
</head>
<body>
  <link rel="stylesheet" href="/style.css" />
  <h1>メモアプリ</h1>
  <form method="get" action="/memo">
    <input type="submit" value="メモ一覧" class="memolist">
  </form>
  <form method="post" action="/memos/<%= @memo["id"]%>">
  <div>
    <input type="text" name="title" value="<%= @memo["title"] %>" class="title">
  </div>
  <div>
    <textarea name="content" row="5" class="content"><%= @memo["content"] %></textarea>
  </div>
  <div>
    <input type="hidden" name="_method" value="patch">
    <input type="submit" value="変更" class="get">
  </div>
  </form>
</body>
</html>
