require 'scale_rb'
require 'net/http'
require_relative './helpers/darwinia'
require_relative './helpers/evm'
require_relative './helpers/tron'

def calc_supplies
  # prepare darwinia metadata
  metadata_content = File.open(File.join(__dir__, 'config', 'darwinia-metadata-1242.json')).read
  metadata = JSON.parse(metadata_content)

  # TOTAL SUPPLY
  darwinia_url = 'https://rpc.darwinia.network'
  total_supply = Darwinia.total_supply(darwinia_url, metadata)

  # DARWINIA ACCOUNTS
  # [ trsry, trobk, multi, fundn ]
  account_ids = %w[
    0x6d6f646c64612f74727372790000000000000000000000000000000000000000
    0x6d6f646c64612f74726f626b0000000000000000000000000000000000000000
    0x8db5c746c14cf05e182b10576a9ee765265366c3b7fd53c41d43640c97f4a8b8
    0x88db6cf10428d2608cd2ca2209971d0227422dc1f53c6ec0848fa610848a6ed3
  ]
  trsry, trobk, multi, fundn = Darwinia.balances_of(darwinia_url, account_ids, metadata)

  # DSC ACCOUNTS
  wring_contract = '0xE7578598Aac020abFB918f33A20faD5B71d670b4'
  ethbk_address = '0xD1B10B114f1975d8BCc6cb6FC43519160e2AA978'
  ethbk = Evm.balance_of(darwinia_url, ethbk_address, wring_contract)

  # TRAN ACCOUNTS
  tronscan_url = 'https://apilist.tronscan.org/api/account'
  ring_contract = 'TL175uyihLqQD656aFx3uhHYe1tyGkmXaW'
  addresses = %w[
    TDWzV6W1L1uRcJzgg2uKa992nAReuDojfQ
    TSu1fQKFkTv95U312R6E94RMdixsupBZDS
    TTW2Vpr9TCu6gxGZ1yjwqy7R79hEH8iscC
  ]
  tron3 = Tron.balances_of(tronscan_url, addresses, ring_contract).sum

  # CALCUATING SUPPLIES
  a = total_supply - ethbk - trobk - trsry - multi - fundn - Darwinia.bonded_locked_balance
  b = ethbk
  c = trobk - tron3
  {
    totalSupply: total_supply,
    circulatingSupply: a + b + c,
    maxSupply: 10_000_000_000
  }
end
