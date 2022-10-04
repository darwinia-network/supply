module Darwinia
  class << self
    def system_account(url, account_id, metadata)
      key_value = [
        [account_id.to_bytes]
      ]
      Client.get_storage3(url, 'System', 'Account', key_value, metadata)
    end

    def total_supply(url, metadata)
      Client.get_storage3(url, 'Balances', 'TotalIssuance', nil, metadata).to_f / 10**9
    end

    def balance_of(url, account_id, metadata)
      account_info = system_account(url, account_id, metadata)
      ring_balance = account_info[:data][:free]
      ring_balance.to_f / 10**9
    end

    def balances_of(url, account_ids, metadata)
      account_ids.map do |account_id|
        balance_of(url, account_id, metadata)
      end
    end

    # from subscan
    def bonded_locked_balance
      uri = URI('https://darwinia.api.subscan.io/api/scan/token')
      result = JSON.parse(Net::HTTP.get(uri))
      result['data']['detail']['RING']['bonded_locked_balance'].to_f / 10**9
    end
  end
end
