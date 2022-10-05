module Trc20
  class << self
    def total_supply(url, token_contract)
      full_url = File.join(url, "token_trc20?contract=#{token_contract}")
      uri = URI(full_url)
      result = JSON.parse(Net::HTTP.get(uri))
      the_token = result['trc20_tokens'].first
      decimals = the_token['decimals']
      the_token['totalTurnOver'].to_f / 10**decimals
    end

    def balance_of(url, address, token_contract)
      full_url = File.join(url, "account?address=#{address}")
      uri = URI(full_url)
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
