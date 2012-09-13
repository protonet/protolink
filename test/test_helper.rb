$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require "rubygems"
require "protolink"
require "test/unit"

require 'ruby-debug'
Debugger.start

class Test::Unit::TestCase

  def setup
    @api_server = "http://localhost:3000"
    @api_user = "admin"
    @api_pass = "admin"
  end

end
