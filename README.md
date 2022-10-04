# Supply

Server providing data of Darwina assets supply.

Ruby lang should be installed first.

## Install

1. Install server

   ```bash
   git clone https://github.com/darwinia-network/supply 
   cd supply
   bundle install
   ```

2. Install your crontab schedule

   ```bash
   whenever --update-crontab
   ```
   This crontab will update data every minute.

   > You can run `bundle exec whenever` to see you cron syntax schedule.
   > This command will simply show you your `schedule.rb` file converted to cron syntax. It does not read or write your crontab file.

## Run
   1. (Optional) install `puma` app server in production
      ```bash
      gem install puma
      ```

   2. Run server
      ```bash
      ruby server.rb
      ```
      ```bash
      curl http://127.0.0.1:4567/supplies
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




