require 'mechanize'
#require 'ipaddress'

module Mtgsy
  class ApiClient
    def initialize(options = {})
      @agent        = Mechanize.new
      @api_endpoint = "https://www.mtgsy.net/dns/api.php"

      # attr_accessor
      @domainname = options[:domainname] ? options[:domainname] : nil
      @username   = options[:username]   ? options[:username]   : nil
      @aux = 0
      @ttl = 1800

      # attr_writer
      @password   = options[:password]   ? options[:password]   : nil
    end

    attr_accessor :domainname, :username, :aux, :ttl
    attr_writer   :password

    def add_record(options={})
      command = "addrecord"
      name    = options[:name] ? options[:name].to_s : (raise "add_record requires :name")
      type    = options[:type] ? options[:type].to_s : (raise "add_record requires :type")
      data    = options[:data] ? options[:data].to_s : (raise "add_record requires :data")
      aux     = options[:aux ] ? options[:aux].to_s  : @aux.to_s
      ttl     = options[:ttl ] ? options[:ttl].to_s  : @ttl.to_s

      @agent.post(@api_endpoint, [
        [ 'command'    ,command     ],
        [ 'username'   ,@username   ],
        [ 'password'   ,@password   ],
        [ 'domainname' ,@domainname ],
        [ 'name'       ,name        ],
        [ 'type'       ,type        ],
        [ 'data'       ,data        ],
        [ 'aux'        ,aux         ],
        [ 'ttl'        ,ttl         ]
      ])

    end

    def delete_record(options={})
      command = "deleterecord"
      puts "TODO: Delete record"
    end

    def update_record(options={})
      command = "updaterecord"
      puts "TODO: Update record"
    end

    private
      def what_happened?(mechanize_instance)
        mechanize_instance.page.code
      end
  end
end
