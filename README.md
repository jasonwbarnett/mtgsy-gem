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

    ## Start things off...
    require 'mtgsy'
    client = Mtgsy::ApiClient.new(username: "my_username", password: "my_password", domainname: "mydomain.com")

    ## Add records
    client.add_record(name: "www1", type: "A", data: "127.0.0.1")
    client.add_record(name: "www2", type: "A", data: "127.0.0.2", ttl: "3600")
    client.add_record(name: "www3", type: "A", data: "127.0.0.3", ttl: "3600", aux: "5")

    ## Update records
    client.update_record(name: "www1", type: "A", data: "127.0.0.11")

    ## Delete records:
    client.delete_record(name: "www1")
    client.delete_record(name: "www2")
    client.delete_record(name: "www3")

    ## List all records in a zone:
    client.records("ALL")    # Returns an array of _all_ records in the zone
    client.records("A")      # Returns an array of all A records in the zone
    client.records("CNAME")  # Returns an array of all CNAME records in the zone
    client.records("AAAA")   # Returns an array of all AAAA records in the zone

    ## List all possible records types:
    client.record_types?

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
