require 'sinatra'
require 'json'

get '/' do
  'Hello Darwinia!'
end

get '/supply/ring' do
  content_type :json
  result = File.read(File.join(__dir__, 'supplies.json'))
  result = JSON.parse(result)
  {
    code: 0,
    data: result['ringSupplies']
  }.to_json
end

get '/supply/kton' do
  content_type :json
  result = File.read(File.join(__dir__, 'supplies.json'))
  result = JSON.parse(result)
  {
    code: 0,
    data: result['ktonSupplies']
  }.to_json
end

get '/seilppuswithbalances' do
  content_type :json
  File.read(File.join(__dir__, 'supplies.json'))
end

not_found do
  content_type :json
  status 404
  {
    error: 404
  }.to_json
end
