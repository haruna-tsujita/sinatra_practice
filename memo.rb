# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'erb'

def write_memo(id, title, content)
  connection = PG.connect(dbname: 'memo_data')
  connection.exec('INSERT INTO memo_data(id, title, content) VALUES($1,$2,$3)', [id, title, content])
end

def read_memo
  connection = PG.connect(dbname: 'memo_data')
  @memos = connection.exec('SELECT * FROM memo_data')
end

def show_memo(id)
  connection = PG.connect(dbname: 'memo_data')
  @memo = connection.exec('SELECT * FROM memo_data WHERE id = $1', [id])
end

def overwrite_memo(id, title, content)
  connection = PG.connect(dbname: 'memo_data')
  connection.exec("UPDATE memo_data SET title = '#{title}', content = '#{content}' WHERE id = $1", [id])
end

def delete(id)
  connection = PG.connect(dbname: 'memo_data')
  connection.exec('DELETE FROM memo_data WHERE id = $1', [id])
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
  write_memo(SecureRandom.uuid, params[:title], params[:content])
  redirect to('/memo')
end

get '/new_memo' do
  erb :new_memo
end

get '/memos/:id' do
  show_memo(params[:id])
  erb :show_memo
end

delete '/memos/:id' do
  delete(params[:id])
  redirect to('/memo')
  erb :show_memo
end

get '/memos/:id/edit' do
  show_memo(params[:id])
  erb :edit_memo
end

patch '/memos/:id' do
  show_memo(params[:id])
  overwrite_memo(params[:id], params[:title], params[:content])
  redirect to("/memos/#{params[:id]}")
end
