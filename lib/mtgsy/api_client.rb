require 'mechanize'
#require 'ipaddress'

module Mtgsy
  class ApiClient
    def initialize(options = {})
      @agent        = Mechanize.new
      @api_endpoint = "https://www.mtgsy.net/dns/api.php"
      @record_types = [ 'A', 'AAAA', 'CNAME', 'HINFO', 'MX', 'NS', 'PTR', 'RP', 'SRV', 'TXT' ]

      @debug        = options[:debug] ? options[:debug] : false

      # attr_accessor
      @domainname = options[:domainname] ? options[:domainname] : nil
      @username   = options[:username]   ? options[:username]   : nil
      @ttl        = options[:ttl]        ? options[:ttl]        : 900
      @aux = 0

      # attr_writer
      @password     = options[:password]   ? options[:password]   : nil
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

    def refresh!
      command = "listrecords"
      post_to_mtgsy([ command ])

      @records_ALL = @agent.page.body.split('<br>')
      @records_ALL.pop
      @records_ALL.collect! { |i| i.split(",") }


      @record_types.each do |x|
        tmp_placeholder = []
        @records_ALL.each do |record|
          tmp_placeholder << record if record[RECORD_TYPE] == x
        end
        instance_variable_set("@records_#{x}", tmp_placeholder)
      end
    end

    def records(type="ALL")
      self.refresh! unless @records

      eval("@records_#{type}")
    end

    def record_types?
      @record_types
    end

    private
      def post_to_mtgsy(params)
        command = params[Mtgsy::POST_COMMAND]
        name    = params[Mtgsy::POST_NAME]
        type    = params[Mtgsy::POST_TYPE]
        data    = params[Mtgsy::POST_DATA]
        aux     = params[Mtgsy::POST_AUX]
        data    = params[Mtgsy::POST_TTL]

        post_data = []
        post_data << [ 'command'    ,command ]     if command
        post_data << [ 'username'   ,@username ]   if @username
        post_data << [ 'password'   ,@password ]   if @password
        post_data << [ 'domainname' ,@domainname ] if @domainname
        post_data << [ 'name'       ,name ]        if name
        post_data << [ 'type'       ,type ]        if type
        post_data << [ 'data'       ,data ]        if data
        post_data << [ 'aux'        ,aux ]         if aux
        post_data << [ 'ttl'        ,ttl ]         if ttl

        p post_data if @debug

        @agent.post(@api_endpoint, post_data)
      end

      def what_happened?(mechanize_instance, command)
        mtgsy_return_code = mechanize_instance.page.body.match(/[0-9]+/)[0].to_i

        case mtgsy_return_code
        when 800
            puts "OK"
        when 400
          $stderr.puts "No domain name specified"
        when 100
          $stderr.puts "Balance insufficcient"
        when 300
          $stderr.puts "Invalid login information supplied"
        when 305
          $stderr.puts "Domain not found"
        when 310
          $stderr.puts "Record not found / problem adding record"
        when 200
          $stderr.puts "Insufficcient information supplied"
        end
      end
  end
end
