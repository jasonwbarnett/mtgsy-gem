require "mtgsy/version"
require "mtgsy/api_client"

module Mtgsy
  # e.g. post_to_mtgsy([ command, name, type, data, aux, ttl ])
  POST_COMMAND = 0
  POST_NAME    = 1
  POST_TYPE    = 2
  POST_DATA    = 3
  POST_AUX     = 4
  POST_TTL     = 5

  # For the record types, e.g. ["vc32staging", "A", "50.56.9.191", "0", "123"]
  RECORD_NAME = 0
  RECORD_TYPE = 1
  RECORD_DATA = 2
  RECORD_AUX  = 3
  RECORD_TTL  = 4
end
