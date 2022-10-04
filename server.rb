require 'sinatra'
require 'json'

get '/' do
  'Hello Darwinia!'
end

get '/supplies' do
  content_type :json
  File.read(File.join(__dir__, 'supplies.json'))
end
