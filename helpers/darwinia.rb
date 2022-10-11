require_relative './evm'

module Darwinia
  class << self
    def system_account(url, account_id, metadata, at = nil)
      key_value = [
        [account_id.to_bytes]
      ]
      result = Substrate::Client.get_storage3(url, 'System', 'Account', key_value, metadata, at)
      result[:data].transform_values! { |v| v.to_f / 10**9 }
      result
    end

    def balances_total_issuance(url, metadata, at = nil)
      Substrate::Client.get_storage3(url, 'Balances', 'TotalIssuance', nil, metadata, at).to_f / 10**9
    end

    def system_number(url, metadata)
      Substrate::Client.get_storage3(url, 'System', 'Number', nil, metadata)
    end

    # returns: [ring_staking_amount, kton_staking_amount]
    def locked_balance_by_bonding(url, metadata, account_id = nil, at = nil)
      value_of_key = ([[account_id.to_bytes]] unless account_id.nil?)
      items = Substrate::Client.get_storage3(url, 'Staking', 'Ledger', value_of_key, metadata, at)
      items.reduce({ ring: 0, kton: 0 }) do |sums, item|
        # ring staking amount
        ring_staking_amount = item[:storage][:active]

        # kton staking amount
        kton_staking_amount = item[:storage][:active_kton]

        {
          ring: sums[:ring] + ring_staking_amount / 10**9.to_f,
          kton: sums[:kton] + kton_staking_amount / 10**9.to_f
        }
      end
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

      def locked_balance_by_bonding(url, metadata, account_id = nil, at = nil)
        value_of_key = ([[account_id.to_bytes]] unless account_id.nil?)
        storages = Substrate::Client.get_storage3(url, 'Kton', 'Locks', value_of_key, metadata, at)
        balance = storages.reduce(0) do |sum, item|
          id = item[:storage][0][0][:id].to_utf8
          amount = item[:storage][0][0][:amount]
          id == 'da/staki' ? sum + amount : sum
        end
        balance / 10**9
      end
    end
  end
end
