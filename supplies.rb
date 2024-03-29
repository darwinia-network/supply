require 'scale_rb'
require 'net/http'
require_relative './helpers/darwinia'
require_relative './helpers/tron'
require_relative './helpers/evm'

def supplies
  # prepare darwinia metadata
  metadata_content = File.read(File.join(__dir__, 'config', 'darwinia-metadata-1242.json'))
  metadata = JSON.parse(metadata_content)

  darwinia_url = 'https://rpc.darwinia.network'
  ethereum_url = 'https://eth-mainnet.g.alchemy.com/v2/YXraeqSzO1wUUOD2WC51zLUyecVFwj6h'
  tronscan_url = 'https://apilist.tronscan.org/api'

  # get bonded locked data
  bonded = Darwinia.locked_balance_by_bonding(darwinia_url, metadata)

  # ##########################
  # RING
  # ##########################
  ring_balances = _ring_balances(darwinia_url, metadata).merge({ bonded: bonded[:ring] })
  ring_locked = # locked(bonded, illiquid) RING
    ring_balances[:trsry] +
    ring_balances[:fundn] +
    ring_balances[:bonded]
  # ring supplies result
  ring_total_supply = Darwinia::Ring.total_supply(darwinia_url, metadata)
  ring_circulating_supply = ring_total_supply - ring_locked

  # ##########################
  # KTON
  # ##########################
  kton_balances = _kton_balances(ethereum_url, tronscan_url).merge({ bonded: bonded[:kton] })
  kton_locked = kton_balances[:bonded] # - kton_balances[:trobk] # locked(bonded, illiquid) KTON
  # kton supplies result
  kton_total_supply = Darwinia::Kton.total_supply(darwinia_url)
  kton_circulating_supply = kton_total_supply - kton_locked

  {
    ringSupplies: {
      totalSupply: ring_total_supply,
      circulatingSupply: ring_circulating_supply,
      maxSupply: 10_000_000_000
    },
    ringBalances: ring_balances,
    ktonSupplies: {
      totalSupply: kton_total_supply,
      circulatingSupply: kton_circulating_supply,
      maxSupply: kton_total_supply
    },
    ktonBalances: kton_balances
  }
end

# get ring balances of important accounts
def _ring_balances(darwinia_url, metadata)
  # darwinia accounts: trobk, trsry, fundn
  account_ids = %w[
    0x6d6f646c64612f74726f626b0000000000000000000000000000000000000000
    0x6d6f646c64612f74727372790000000000000000000000000000000000000000
    0x8db5c746c14cf05e182b10576a9ee765265366c3b7fd53c41d43640c97f4a8b8
  ]
  trobk, trsry, fundn = Darwinia::Ring.balances_of(darwinia_url, account_ids, metadata)

  # dsc account: ethbk
  wring_contract = '0xE7578598Aac020abFB918f33A20faD5B71d670b4'
  ethbk_address = '0xD1B10B114f1975d8BCc6cb6FC43519160e2AA978'
  ethbk = Erc20.balance_of(darwinia_url, ethbk_address, wring_contract)

  {
    ethbk: ethbk, # backing rings for ethereum
    trobk: trobk, # backing rings for tron
    trsry: trsry, # treasury balance
    fundn: fundn # foundation balance
  }
end

# def _bonded_locked_ring(darwinia_url, metadata)
#   Darwinia.locked_balance_by_bonding(darwinia_url, metadata)
# end
#
# metadata_content = File.read(File.join(__dir__, 'config', 'darwinia-metadata-1242.json'))
# metadata = JSON.parse(metadata_content)
# p _bonded_locked_ring('https://rpc.darwinia.network', metadata)

# get kton balances of important accounts
def _kton_balances(ethereum_url, tronscan_url)
  # ethereum
  kton_contract_on_ethereum = '0x9F284E1337A815fe77D2Ff4aE46544645B20c5ff'
  ethbk = Erc20.total_supply(ethereum_url, kton_contract_on_ethereum)

  # tron
  kton_contract_on_tron = 'TW3kTpVtYYQ5Ka1awZvLb9Yy6ZTDEC93dC'
  trobk = Trc20.total_supply(tronscan_url, kton_contract_on_tron)
  {
    ethbk: ethbk,
    trobk: trobk
  }
end
