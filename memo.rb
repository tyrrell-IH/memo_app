#! /usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'securerandom'
require 'sinatra'

set :environment, :production
set :method_override, true

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def create_memo(title, text)
  memo_id = SecureRandom.hex.to_s
  { memo_id => { 'title' => title, 'text' => text } }
end

def release_memos(filename)
  file = File.read(filename)
  if file.empty?
    {}
  else
    JSON.parse(file)
  end
end

def store_memos(filename, memos)
  File.open(filename, 'w') do |file|
    JSON.dump(memos, file)
  end
end

get '/memos' do
  memos = release_memos('memodb.json')
  @titles = memos.map do |key, values|
    "<a href=\"/memos/#{key}\">#{values['title']}</a><br>"
  end.join('')
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  new_memo = create_memo(h(params[:title]), h(params[:text]))
  memos = release_memos('memodb.json')
  memos.merge!(new_memo)
  store_memos('memodb.json', memos)
  redirect '/memos'
end

get '/memos/:memo_id' do
  @memo_id = params[:memo_id]
  memos = release_memos('memodb.json')
  @title = memos[@memo_id]['title']
  @text = memos[@memo_id]['text']
  erb :detail
end

get '/memos/:memo_id/edit' do
  @memo_id = params[:memo_id]
  memos = release_memos('memodb.json')
  @title = memos[@memo_id]['title']
  @text = memos[@memo_id]['text']
  erb :edit
end

patch '/memos/:memo_id' do
  memo_id = params[:memo_id]
  memos = release_memos('memodb.json')
  memos[memo_id] = { 'title' => h(params[:title]), 'text' => h(params[:text]) }
  store_memos('memodb.json', memos)
  redirect '/memos'
end

delete '/memos/:memo_id' do
  memo_id = params[:memo_id]
  memos = release_memos('memodb.json')
  memos.delete(memo_id)
  store_memos('memodb.json', memos)
  redirect '/memos'
end
