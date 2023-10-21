#! /usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'pg'

set :environment, :production
set :method_override, true

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

class MemoDB
  @@conn = PG.connect(host: "localhost", user: "postgres", password: "未設定", dbname: "memo")

  def self.pull_out
    @@conn.exec("SELECT * FROM Memos ORDER BY id;")
  end

  def self.insert(title, text)
    @@conn.exec("INSERT INTO Memos (title, text) VALUES ('#{title}', '#{text}');")
  end

  def self.find(memo_id)
    memos = @@conn.exec("SELECT * FROM Memos;")
    memos.find{|memo| memo['id'] == memo_id}
  end

  def self.update(memo_id, title, text)
    @@conn.exec("UPDATE Memos SET title = '#{title}', text = '#{text}' WHERE id = #{memo_id};")
  end

  def self.delete(memo_id)
    @@conn.exec("DELETE FROM Memos WHERE id = #{memo_id}")
  end
end

get '/memos' do
  @memos = MemoDB.pull_out
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  MemoDB.insert(params[:title], params[:text])
  redirect '/memos'
end

get '/memos/:memo_id' do
  @memo = MemoDB.find(params[:memo_id])
  erb :detail
end

get '/memos/:memo_id/edit' do
  @memo = MemoDB.find(params[:memo_id])
  erb :edit
end

patch '/memos/:memo_id' do
  MemoDB.update(params[:memo_id], params[:title], params[:text])
  redirect '/memos'
end

delete '/memos/:memo_id' do
  MemoDB.delete(params[:memo_id])
  redirect '/memos'
end
