require 'scale_rb'
require 'net/http'
require_relative './helpers/darwinia'
require_relative './helpers/tron'

def calc_and_write_supplies_to_file
  supplies = calc_supplies
  File.write(File.join(__dir__, 'supplies.json'), supplies.to_json)
end

def calc_supplies
  # prepare darwinia metadata
  metadata_content = File.read(File.join(__dir__, 'config', 'darwinia-metadata-1242.json'))
  metadata = JSON.parse(metadata_content)

  # ##########################
  # RING TOTAL SUPPLY
  # ##########################
  darwinia_url = 'https://rpc.darwinia.network'
  total_supply = Darwinia.total_supply(darwinia_url, metadata)

  # ##########################
  # ILLIQUID AND BONDED RING
  # ##########################
  # illiquid ring on darwinia, [ trsry, multi, fundn ]
  account_ids = %w[
    0x6d6f646c64612f74727372790000000000000000000000000000000000000000
    0x8db5c746c14cf05e182b10576a9ee765265366c3b7fd53c41d43640c97f4a8b8
    0x88db6cf10428d2608cd2ca2209971d0227422dc1f53c6ec0848fa610848a6ed3
  ]
  illiquid_on_darwinia = Darwinia.balances_of(darwinia_url, account_ids, metadata).sum

  # locked ring by bonded, from subscan
  bonded_on_darwinia = Darwinia.bonded_locked_balance

  # illiquid ring on tron
  tronscan_url = 'https://apilist.tronscan.org/api/account'
  ring_contract = 'TL175uyihLqQD656aFx3uhHYe1tyGkmXaW'
  addresses = %w[
    TDWzV6W1L1uRcJzgg2uKa992nAReuDojfQ
    TSu1fQKFkTv95U312R6E94RMdixsupBZDS
    TTW2Vpr9TCu6gxGZ1yjwqy7R79hEH8iscC
  ]
  illiquid_on_tron = Tron.balances_of(tronscan_url, addresses, ring_contract).sum

  # ##########################
  # CALCUATING SUPPLIES
  # ##########################
  {
    totalSupply: total_supply,
    circulatingSupply: total_supply - bonded_on_darwinia - illiquid_on_darwinia - illiquid_on_tron,
    maxSupply: 10_000_000_000
  }
end
