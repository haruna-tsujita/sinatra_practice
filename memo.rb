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
  @id = params[:id]
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
      <li><a href="/show_memo<% memo["id"] %>"><%= memo["title"] %></a></li>
    <% end %>
  </ul>
  <p><a href=/new_memo>追加</a></p>
  <p><a href=/show_memo>中身を見る</a></p>
  
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
  <form method="post" action="top">
    <input type="text" name="title" id="title" value="">
    <textarea name="content" id="memo" value="" rows="3"></textarea>
    <input type="submit" value="送信">
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
  <p>メモの内容</p>
  <form method="get" action="edit_memo">
    <input type="submit" value="変更">
  </form>
  <form method="get" action="top">
    <input type="submit" value="削除">
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
  <form method="get" action="top">
    <input type="submit" value="変更">
  </form>
</body>
</html>

