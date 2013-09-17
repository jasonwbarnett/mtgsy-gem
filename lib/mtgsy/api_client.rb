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
      @ttl        = options[:ttl]        ? options[:ttl]        : 900
      @aux = 0

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

      post_to_mtgsy([ command, name, type, data, aux, ttl ])

      what_happened?(@agent, command)
    end

    def delete_record(options={})
      command = "deleterecord"
      name    = options[:name] ? options[:name].to_s : (raise "delete_record requires :name")
      type    = options[:type] ? options[:type].to_s : nil
      data    = options[:data] ? options[:data].to_s : nil
      aux     = options[:aux ] ? options[:aux].to_s  : nil
      ttl     = options[:ttl ] ? options[:ttl].to_s  : nil

      post_to_mtgsy([ command, name, type, data, aux, ttl ])

      what_happened?(@agent, command)
    end

    def update_record(options={})
      command = "updaterecord"
      name    = options[:name] ? options[:name].to_s : (raise "update_record requires :name")
      type    = options[:type] ? options[:type].to_s : nil
      data    = options[:data] ? options[:data].to_s : nil
      aux     = options[:aux ] ? options[:aux].to_s  : nil
      ttl     = options[:ttl ] ? options[:ttl].to_s  : nil

      post_to_mtgsy([ command, name, type, data, aux, ttl ])

      what_happened?(@agent, command)
    end

    private
      def post_to_mtgsy(params)
        command = params[Mtgsy::COMMAND]
        name    = params[Mtgsy::NAME]
        type    = params[Mtgsy::TYPE]
        data    = params[Mtgsy::DATA]
        aux     = params[Mtgsy::AUX]
        data    = params[Mtgsy::TTL]

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

      def what_happened?(mechanize_instance, command)
        mtgsy_return_code = mechanize_instance.page.body.match(/[0-9]+/)[0].to_i

        case mtgsy_return_code
        when 800
          if command =~ /update|delete/
            puts "OK"
          else
            puts "Created"
          end
        when 400
          puts "No domain name specified"
        when 100
          puts "Balance insufficcient"
        when 300
          puts "Invalid login information supplied"
        when 305
          puts "Domain not found"
        when 310
          puts "Record not found / problem adding record"
        when 200
          puts "Insufficcient information supplied"
        end

      end
  end
end
