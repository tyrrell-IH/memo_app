#! /usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'securerandom'
require 'sinatra'
require 'pg'

set :environment, :production
set :method_override, true

MEMO_DB = 'memodb.json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

class MemoDB
  @@conn = PG.connect(host: "localhost", user: "postgres", password: "未設定", dbname: "memo")

  def pull_out
    @@conn.exec("SELECT * FROM Memos;")
  end

  def insert(title, text)
    @@conn.exec("INSERT INTO Memos (title, text) VALUES ('#{title}', '#{text}');")
  end

  def find(memo_id)
    memos = @@conn.exec("SELECT * FROM Memos;")
    memos.find{|memo| memo['id'] == memo_id}
  end

  def update(memo_id, title, text)
    @@conn.exec("UPDATE Memos SET title = '#{title}', text = '#{text}' WHERE id = #{memo_id};")
  end

  def delete(memo_id)
    @@conn.exec("DELETE FROM Memos WHERE id = #{memo_id}")
  end
end

get '/memos' do
  @memos = MemoDB.new.pull_out
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  MemoDB.new.insert(params[:title], params[:text])
  redirect '/memos'
end

get '/memos/:memo_id' do
  @memo = MemoDB.new.find(params[:memo_id])
  erb :detail
end

get '/memos/:memo_id/edit' do
  @memo = MemoDB.new.find(params[:memo_id])
  erb :edit
end

patch '/memos/:memo_id' do
  MemoDB.new.update(params[:memo_id], params[:title], params[:text])
  redirect '/memos'
end

delete '/memos/:memo_id' do
  MemoDB.new.delete(params[:memo_id])
  redirect '/memos'
end
