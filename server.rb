require 'sinatra'
require 'json'

require 'scale_rb'
require_relative './helpers/darwinia'

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
