require 'eventmachine'
require_relative 'protolink/flash_connection'
require_relative 'protolink/proto_socket'
require_relative 'protolink/protonet'
require_relative 'protolink/project'
require_relative 'protolink/user'
require_relative 'protolink/subscription'
require_relative 'protolink/topic'


module Protolink
  class Error < StandardError; end
  class SSLRequiredError < Error; end
  class AuthenticationFailed < Error; end
  class ListenFailed < Error; end
end
