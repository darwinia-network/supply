module Subscan
  class << self
    def bonded_locked_balances(url)
      uri = URI(url)
      data = JSON.parse(Net::HTTP.get(uri))
      {
        ring: data['data']['detail']['RING']['bonded_locked_balance'].to_f / 10**9,
        kton: data['data']['detail']['KTON']['bonded_locked_balance'].to_f / 10**9
      }
    end
  end
end
