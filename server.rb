require 'sinatra'
require 'json'

get '/' do
  'Hello Darwinia!'
end

get '/supplies' do
  content_type :json
  result = File.read(File.join(__dir__, 'supplies.json'))
  result = JSON.parse(result)
  {
    ringSupplies: result['ringSupplies'],
    ktonSupplies: result['ktonSupplies']
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
