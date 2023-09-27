require 'csv'
require 'sinatra'
require 'sinatra/reloader'

set :environment, :production

class Memo
  @@memo_id = CSV.read('memodb.csv')[-1][0].to_i
  def initialize(title, text)
    @title = title
    @text = text
    @@memo_id += 1
  end
  def generate_contents
    [@@memo_id, @title, @text]
  end
end

get "/memos" do
  @titles = ""
  CSV.foreach('memodb.csv') do |memo|
    @titles.concat("<a href=\"/memos/#{memo[0]}\">#{memo[1]}</a><br>")
  end
  erb :index
end

get "/memos/new" do
  erb :new
end

post "/memos" do
  CSV.open('memodb.csv', 'a') do |csv|
    memo = Memo.new(params[:title], params[:text])
    csv << memo.generate_contents
  end
  redirect '/memos'
end

get "/memos/:memo_id" do
  memo_id = params[:memo_id]
  @memo_id, @title, @text = CSV.read('memodb.csv').find{|memo| memo[0] == "#{memo_id}"}
  erb :detail
end

get "/memos/:memo_id/edit" do
  memo_id = params[:memo_id]
  @memo_id, @title, @text = CSV.read('memodb.csv').find{|memo| memo[0] == "#{memo_id}"}
  erb :edit
end

patch "/memos/:memo_id" do

end

delete "/memos/:memo_id" do

end
