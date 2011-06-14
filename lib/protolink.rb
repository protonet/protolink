require 'active_support'
require 'active_support/json'
require 'mime/types'

require 'protolink/connection'
require 'protolink/protonet'
require 'protolink/channel'
require 'protolink/user'
require 'protolink/listen'
require 'protolink/middleware'

module Protolink
  class Error < StandardError; end
  class SSLRequiredError < Error; end
  class AuthenticationFailed < Error; end
  class ListenFailed < Error; end
end
