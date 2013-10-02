#!/usr/bin/env ruby
require 'optparse'
require 'mtgsy'
begin
  require 'io/console'
rescue LoadError
end

more_than_one_command_flag=false
options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename($0)} [options]"

  opts.on("-u", "--username USERNAME",
    "Username to authenticate to mtgsy.net"
  ) { |value| options[:username] = value }

  opts.on("-p", "--password PASSWORD",
    "Password to authenticate to mtgsy.net"
  ) { |value| options[:password] = value }

  opts.on("--add",
    "Use this opt to add the record."
  ) { |value| more_than_one_command_flag=true if options[:command]; options[:command] = "add" }

  opts.on("--delete",
    "Use this opt to delete the record."
  ) { |value| more_than_one_command_flag=true if options[:command]; options[:command] = "delete" }

  opts.on("--update",
    "Use this opt to udate the record."
  ) { |value| more_than_one_command_flag=true if options[:command]; options[:command] = "update" }

  opts.on("--domain DOMAINNAME",
    "Domain name / Zone to interact with"
  ) { |value| options[:domainname] = value }

  opts.on("--name NAME",
    "Record name, e.g. www, *.cust, random.thing, etc..."
  ) { |value| options[:name] = value }

  opts.on("--type TYPE",
    "Record type, e.g. A, CNAME, TXT, etc..."
  ) { |value| options[:type] = value }

  opts.on("--data DATA",
    "Record data, e.g. 56.56.23.233, my.ssl.zendesk.com., etc..."
  ) { |value| options[:data] = value }

  opts.on("--aux AUX",
    "Record aux, info: http://www.mtgsy.net/dns/record_aux.htm"
  ) { |value| options[:aux] = value }

  opts.on("--ttl TTL",
    "Record TTL, e.g. 300, 900, 1800, 3600, etc..."
  ) { |value| options[:ttl] = value }

  opts.on("-x", "--debug",
    "Enables some helpful debugging output."
  ) { |value| options[:debug] = true }

  opts.on("-h", "--help", "Display this help message.") do
    puts opts
    exit
  end
end

begin
  optparse.parse!
rescue OptionParser::MissingArgument
  puts "You're missing an argument...\n\n"
  puts optparse
  exit 1
end

if more_than_one_command_flag
  $stderr.puts "You must only specify ONE command: --add, --update or --delete"
  puts optparse
  exit 1
end

p options if options[:debug]
p ARGV    if options[:debug]


#######
## MAIN
#######


client = Mtgsy::ApiClient.new

client.username   = options[:username]   if options[:username]
client.domainname = options[:domainname] if options[:domainname]

if options[:password]
  client.password   = options[:password]
else
  print "Please enter your password: "
  client.password = STDIN.noecho(&:gets).chomp
  puts
end

name    = options[:name] ? options[:name].to_s : nil
type    = options[:type] ? options[:type].to_s : nil
data    = options[:data] ? options[:data].to_s : nil
aux     = options[:aux ] ? options[:aux].to_s  : nil
ttl     = options[:ttl ] ? options[:ttl].to_s  : nil

client.add(name: name, type: type, data: data, aux: aux, ttl: ttl)    if options[:command] == "add"
client.delete(name: name, type: type, data: data, aux: aux, ttl: ttl) if options[:command] == "delete"
client.update(name: name, type: type, data: data, aux: aux, ttl: ttl) if options[:command] == "update"
