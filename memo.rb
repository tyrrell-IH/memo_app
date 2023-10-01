require 'json'
require "securerandom"
require 'sinatra'
require 'sinatra/reloader'

set :environment, :production
set :method_override, true

class Memo
  def initialize(title, text)
    @title = title
    @text = text
    @memo_id = SecureRandom.hex
  end
  def generate_contents
    {@memo_id.to_s => {'title' => @title, 'text' => @text}}
  end
end

get "/memos" do
  @titles = ""
  File.open('memodb.json') do |file|
    memos = JSON.load(file)
    memos.each do |key, value|
      @titles.concat("<a href=\"/memos/#{key}\">#{value['title']}</a><br>")
    end if memos
  end
  erb :index
end

get "/memos/new" do
  erb :new
end

post "/memos" do
  new_memo = Memo.new(params[:title], params[:text]).generate_contents
  json_file = File.read('memodb.json')
  saved_memos = JSON.load(json_file)
  File.open('memodb.json', 'w') do |file|
    if saved_memos.empty?
      JSON.dump(new_memo, file)
    else
      saved_memos.merge!(new_memo)
      JSON.dump(saved_memos, file)
    end
  end
  redirect '/memos'
end

get "/memos/:memo_id" do
  @memo_id = params[:memo_id]
  json_file = File.read('memodb.json')
  saved_memos = JSON.load(json_file)
  @title = saved_memos[@memo_id]['title']
  @text = saved_memos[@memo_id]['text']
  erb :detail
end

get "/memos/:memo_id/edit" do
  @memo_id = params[:memo_id]
  json_file = File.read('memodb.json')
  saved_memo = JSON.load(json_file)
  @title = saved_memo[@memo_id]['title']
  @text = saved_memo[@memo_id]['text']
  erb :edit
end

patch "/memos/:memo_id" do
  memo_id = params[:memo_id]
  json_file = File.read('memodb.json')
  saved_memos = JSON.load(json_file)
  saved_memos[memo_id] = {'title' => params[:title], 'text' => params[:text]}
  File.open('memodb.json', 'w') do |file|
    JSON.dump(saved_memos, file)
  end
  redirect '/memos'
end

delete "/memos/:memo_id" do
  memo_id = params[:memo_id]
  json_file = File.read('memodb.json')
  saved_memos = JSON.load(json_file)
  saved_memos.delete(memo_id)
  File.open('memodb.json', 'w') do |file|
    JSON.dump(saved_memos, file)
  end
  redirect '/memos'
end
