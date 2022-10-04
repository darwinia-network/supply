require 'sinatra'
require 'json'
require_relative './supplies'

get '/' do
  'Hello Darwinia!'
end

get '/supplies' do
  content_type :json
  calc_supplies.to_json
end
