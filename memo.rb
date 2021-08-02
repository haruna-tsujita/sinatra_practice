require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'erb'
require 'SecureRandom'

def write_memo
  @title = params[:"title"]
  @content = params[:"content"]
  memo = { "id" => SecureRandom.uuid, "title" => @title, "content" => @content }
  File.open("data/memos_#{memo["id"]}.json", "w") {|file| JSON.dump(memo, file)}
end

def read_memo
  files = Dir.glob("data/*")
  @memos = files.map {|file| JSON.load(File.read(file))}
end

def show_memo
  @id = params[:id]
  read_memo
  @memo = @memos.find {|x| x["id"].include?(@id)}
end

def overwrite_memo
  @id = params[:"id"]
  @title = params[:"title"]
  @content = params[:"content"]
  memo = { "id" => @id, "title" => @title, "content" => @content }
  File.open("data/memos_#{memo["id"]}.json", "w") {|file| JSON.dump(memo, file)}
end

get '/memo' do
  read_memo
  erb :memo_top
end

post '/memo' do
  write_memo
  read_memo
  erb :memo_top
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
  redirect to ("/memo")
  erb :show_memo
end

get '/memos/:id/edit' do
  show_memo
  erb :edit_memo
end

patch '/memos/:id' do
  show_memo
  overwrite_memo
  redirect to ("/memos/#{@id}")
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
  <h1>メモアプリ</h1>
  <ul>
    <% @memos.each do |memo| %>
      <li><a href="/memos/<%= memo["id"] %>"><%= memo["title"] %></a></li>
    <% end %>
  </ul>
  <p><a href=/new_memo>追加</a></p>
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
  <p>ここに入力してください</p>
  <form method="post" action="memo">
    <input type="text" name="title" id="title" value=""></br>
    <textarea name="content" id="memo" value="" rows="3"></textarea></br>
    <input type="submit" value="送信">
  </form>
  <form method="get" action="memo">
    <input type="submit" value="メモ一覧">
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
  <h1>メモアプリ</h1>
  <h2>タイトル</h2>
    <p><%= @memo["title"] %></p>
  <h2>本文</h2>
    <p><%= @memo["content"] %></p>
  <form method="get" action="/memos/<%= @memo["id"]%>/edit">
    <input type="submit" value="変更">
  </form>
  <form method="post">
    <input type="hidden" name="_method" value="delete">
    <input type="submit" value="削除">
  </form>
  <form method="get" action="/memo">
    <input type="submit" value="メモ一覧">
  </form>
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
  <h1>メモアプリ</h1>
  <p>メモの内容（編集画面）</p>
  <form method="post" action="/memos/<%= @memo["id"]%>">
  <div>
    <input type="text" name="title" value="<%= @memo["title"] %>">
  </div>
  <div>
    <textarea name="content" row="5"><%= @memo["content"] %></textarea>
  </div>
  <div>
    <input type="hidden" name="_method" value="patch">
    <input type="submit" value="変更">
  </div>
  </form>
  <form method="get" action="/memo">
    <input type="submit" value="メモ一覧">
  </form>
</body>
</html>
