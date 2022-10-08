# Supply

Server providing data of Darwina assets supply.

## Important Files

* server.rb
  server which provide http api.

* supplies.rb
  the `supplies()` function in this file is to get the newest supplies data.

## Pre
```bash
# install build tools
sudo apt update 
sudo apt install build-essential 

# install ruby and bundler
sudo apt install ruby
gem install bundler

# install rust, needed by gem `blake2b_rs`
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Install

```bash
git clone https://github.com/darwinia-network/supply 
cd supply
bundle install
```

## Add Crontab

update supplies data every 1 minute.

```
* * * * * /bin/bash -l -c 'cd <PATH_YOUR_SUPPLY_DIR> && rake supplies >/dev/null 2>&1'
```

## Run Server
   1. (Optional) install `puma` app server in production
      ```bash
      gem install puma
      ```

   2. Run server
      ```bash
      ruby server.rb
      ```
      ```bash
      curl http://127.0.0.1:4567/supply/ring
      curl http://127.0.0.1:4567/supply/ring?t=CirculatingSupply
      curl http://127.0.0.1:4567/supply/ring?t=TotalSupply
      curl http://127.0.0.1:4567/supply/ring?t=MaxSupply

      curl http://127.0.0.1:4567/supply/kton
      curl http://127.0.0.1:4567/supply/kton?t=CirculatingSupply
      curl http://127.0.0.1:4567/supply/kton?t=TotalSupply
      curl http://127.0.0.1:4567/supply/kton?t=MaxSupply

      curl http://127.0.0.1:4567/seilppuswithbalances
      ```

## Other Operations
* Uninstall crontab:
  ```bash
  crantab -r
  ```

* Update supplies data manually:
  ```bash
  rake supplies
  ```

## DOCKER

### Build Image

```bash
docker build -t supply .
```

### Add Crontab

```
* * * * * <PATH_YOUR_SUPPLY_DIR>/update_supplies.sh >/dev/null 2>&1
```

### Run Server
```bash
<PATH_YOUR_SUPPLY_DIR>/run_server.sh
```
