require_relative './evm'

module Darwinia
  class << self
    def system_account(url, account_id, metadata, at = nil)
      key_value = [
        [account_id.to_bytes]
      ]
      result = Client.get_storage3(url, 'System', 'Account', key_value, metadata, at)
      result[:data].transform_values! { |v| v.to_f / 10**9 }
      result
    end

    def balances_total_issuance(url, metadata, at = nil)
      Client.get_storage3(url, 'Balances', 'TotalIssuance', nil, metadata, at).to_f / 10**9
    end

    def system_number(url, metadata)
      Client.get_storage3(url, 'System', 'Number', nil, metadata)
    end
  end

  module Ring
    class << self
      def total_supply(url, metadata, at = nil)
        Darwinia.balances_total_issuance(url, metadata, at)
      end

      def balance_of(url, account_id, metadata, at = nil)
        account_info = Darwinia.system_account(url, account_id, metadata, at)
        account_info[:data][:free]
      end

      def balances_of(url, account_ids, metadata, at = nil)
        account_ids.map do |account_id|
          balance_of(url, account_id, metadata, at)
        end
      end
    end
  end

  module Kton
    class << self
      def total_supply(url)
        kton_contract = '0x0000000000000000000000000000000000000402'
        Erc20.total_supply(url, kton_contract)
      end

      def balance_of(url, account_id, metadata, at = nil)
        account_info = Darwinia.system_account(url, account_id, metadata, at)
        account_info[:data][:free_kton]
      end
    end
  end
end
