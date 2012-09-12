require 'eventmachine'
require 'protolink/flash_connection'
require 'protolink/proto_socket'
require 'protolink/protonet'
require 'protolink/channel'
require 'protolink/user'
require 'protolink/meep'
require 'protolink/listen'
require 'protolink/node'


module Protolink
  class Error < StandardError; end
  class SSLRequiredError < Error; end
  class AuthenticationFailed < Error; end
  class ListenFailed < Error; end
end
