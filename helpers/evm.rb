module Evm
  class << self
    def balance_of(url, address, token_contract)
      data = "0x70a08231000000000000000000000000#{address[2..]}"
      result = RPC.eth_call(url, token_contract, data, 'latest')
      result.to_i(16)
    end

    def decimals(url, token_contract)
      result = RPC.eth_call(url, token_contract, '0x313ce567', 'latest')
      result.to_i(16)
    end

    def total_supply(url, token_contract)
      result = RPC.eth_call(url, token_contract, '0x18160ddd', 'latest')
      result.to_i(16)
    end
  end
end
