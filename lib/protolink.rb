require 'eventmachine'
require_relative 'protolink/proto_socket'
require_relative 'protolink/protonet'
require_relative 'protolink/project'
require_relative 'protolink/user'
require_relative 'protolink/subscription'
require_relative 'protolink/private_chat'
require_relative 'protolink/topic'
require_relative 'protolink/meep'

module Protolink
  class Error < StandardError; end
  class SSLRequiredError < Error; end
  class AuthenticationFailed < Error; end
  class ListenFailed < Error; end
end
