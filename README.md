# Mtgsy

This Gem helps you update, add and delete DNS records at CloudFloor DNS

## Installation

Add this line to your application's Gemfile:

    gem 'mtgsy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mtgsy

## Usage

    client = Mtgsy::ApiClient.new(username: "my_username", password: "my_password", domainname: "mydomain.com")
    client.add_record(name: "www", type: "A", data: "127.0.0.1", aux: "0", ttl: "3600")

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
