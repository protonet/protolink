require 'protolink/protonet'
require 'protolink/channel'
require 'protolink/user'
require 'protolink/listen'

module Protolink
  class Error < StandardError; end
  class SSLRequiredError < Error; end
  class AuthenticationFailed < Error; end
  class ListenFailed < Error; end
end
