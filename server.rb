require 'sinatra'
require 'json'
require 'scale_rb'

def to_camel(str)
  tmp = str[0].downcase + str[1..]
  splits = tmp.split('_')
  splits[0] + splits[1..].collect(&:capitalize).join
end

get '/' do
  'Hello Darwinia!'
end

get '/supply/ring' do
  result = File.read(File.join(__dir__, 'supplies.json'))
  result = JSON.parse(result)

  if params['t']
    content_type :text
    t = to_camel(params['t'])
    return result['ringSupplies'][t].to_s if %w[totalSupply circulatingSupply maxSupply].include?(t)
  end

  content_type :json
  {
    code: 0,
    data: result['ringSupplies']
  }.to_json
end

get '/supply/kton' do
  result = File.read(File.join(__dir__, 'supplies.json'))
  result = JSON.parse(result)

  if params['t']
    content_type :text
    t = to_camel(params['t'])
    return result['ktonSupplies'][t].to_s if %w[totalSupply circulatingSupply maxSupply].include?(t)
  end

  content_type :json
  {
    code: 0,
    data: result['ktonSupplies']
  }.to_json
end

get '/seilppuswithbalances' do
  content_type :json
  File.read(File.join(__dir__, 'supplies.json'))
end

get '/metadata' do
  content_type :json
  url = params['endpoint'] || 'https://rpc.darwinia.network'
  at = params['block'] || nil
  Substrate::Client.get_metadata(url, at).to_json
end

not_found do
  content_type :json
  status 404
  {
    error: 404
  }.to_json
end
