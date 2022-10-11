# Supply

Server providing data of Darwina assets supply.

[Distribution](./distribution.png)

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

## Run Server
   1. (Optional) install `puma` app server in production
      ```bash
      gem install puma
      ```

   2. Run server
      ```bash
      ./run.sh
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

## DOCKER

### Build Image

```bash
docker build -t supply .
```

### Run Server
```bash
docker run -it -p 4567:4567 --name supply-server supply
```
