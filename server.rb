require 'sinatra'
require 'json'

require 'scale_rb'
require_relative './helpers/darwinia'

get '/' do
  'Hello Darwinia!'
end

get '/supplies' do
  content_type :json
  File.read(File.join(__dir__, 'supplies.json'))
end

get '/kton_supplies' do
  content_type :json
  total_supply = Darwinia::Kton.total_supply('https://rpc.darwinia.network')
  { totalSupply: total_supply }.to_json
end
