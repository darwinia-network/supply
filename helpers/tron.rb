module Tron
  class << self
    def balance_of(url, address, token_contract)
      uri = URI("#{url}?address=#{address}")
      result = JSON.parse(Net::HTTP.get(uri))
      the_token = result['trc20token_balances'].find do |token|
        token['tokenId'].strip == token_contract
      end
      decimals = the_token['tokenDecimal']
      the_token['balance'].to_f / 10**decimals
    end

    def balances_of(url, addresses, token_contract)
      addresses.map do |address|
        balance_of(url, address, token_contract)
      end
    end
  end
end
