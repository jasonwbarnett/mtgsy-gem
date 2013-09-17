require "mtgsy/version"
require "mtgsy/api_client"

module Mtgsy
  # e.g. post_to_mtgsy([ command, name, type, data, aux, ttl ])
  COMMAND = 0
  NAME    = 1
  TYPE    = 2
  DATA    = 3
  AUX     = 4
  TTL     = 5
end
