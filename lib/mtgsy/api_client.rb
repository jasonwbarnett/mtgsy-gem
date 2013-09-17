require 'mechanize'

module Mtgsy
  class ApiClient
    def initialize(options = {})
      @agent = Mechanize.new

      # attr_accessor
      @domainname = options[:domainname] ? options[:domainname] : nil
      @username   = options[:username]   ? options[:username]   : nil

      # attr_writer
      @password   = options[:password]   ? options[:password]   : nil
    end

    attr_accessor @domainname
    attr_accessor @username

    attr_writer   @password
  end
end
