$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require 'rubygems'
require 'protolink'
require "test/unit"

# require 'ruby-debug'
# Debugger.start
# change this if you need to connect to another server
PTN_SERVER = "http://localhost:3000"
PTN_USER   = "dude"
PTN_PASS   = "geheim"
# protonet   = Protolink::Protonet.new('localhost:3000', 'bjoern.dorra', 'geheim')
# 
# user       = protonet.find_or_create_user_by_login("johndoe", "password", "John Doe", "john@doe.com")
# auth_token = user.auth_token
# puts       "user_id     : #{user.id}"
# puts       "user_login  : #{user.login}"
# puts       "auth_token  : #{auth_token}"
# 
# channel    = protonet.find_or_create_channel_by_name("test", "This is a test channel!")
# puts       "channel_id  : #{channel.id}"
# puts       "channel_name: #{channel.name}"
# puts       "channel_desc: #{channel.description}"
# 
# protonet.create_listen(user.id, channel.id)
# 
# puts       "\nhttp://localhost:3000/?auth_token=#{auth_token}"

class TestAll < Test::Unit::TestCase
  
  def teardown
    protonet = Protolink::Protonet.open(PTN_SERVER, PTN_USER, PTN_PASS)
    user = protonet.find_user_by_login("test")
    user.delete!
    user = protonet.find_user_by_login("test_2")
    user.delete!
    channel = protonet.find_channel_by_name("test_foobar")
    channel.delete!
    channel = protonet.find_channel_by_name("test_foobar_2")
    channel.delete!
  end
  
  def test_all
    protonet = Protolink::Protonet.open(PTN_SERVER, PTN_USER, PTN_PASS)
    assert protonet, "Couldn't create connection instance"
    
    user_1 = protonet.create_user(:login => 'test', :email => 'test@test.com')
    assert user_1.is_a?(Protolink::User), "Couldn't create user"
    assert_equal 'test', user_1.login
    assert_equal 'test@test.com', user_1.email
    assert user_1.auth_token.match(/\w+/)
    
    user_2 = protonet.find_or_create_user_by_login('test', :email => 'test@test.com')
    assert_equal user_1.id, user_2.id
    
    user_3 = protonet.find_or_create_user_by_login('test_2', :email => 'test_2@test.com')
    assert user_3.is_a?(Protolink::User), "Couldn't create user"
    assert_equal 'test_2', user_3.login
    assert_equal 'test_2@test.com', user_3.email
    
    channel_1 = protonet.create_channel(:name => "test_foobar", :skip_autosubscribe => true)
    assert channel_1.is_a?(Protolink::Channel), "Couldn't create channel"
    assert_equal 'test_foobar', channel_1.name
    
    channel_2 = protonet.find_or_create_channel_by_name("test_foobar")
    assert_equal channel_1.id, channel_2.id
    
    channel_3 = protonet.find_or_create_channel_by_name("test_foobar_2")
    assert channel_3.is_a?(Protolink::Channel), "Couldn't create channel"
    assert_equal 'test_foobar_2', channel_3.name
    
    protonet.create_listen(user_1.id, channel_1.id)
    protonet.create_listen(user_3.id, channel_1.id)
    
    assert_equal [user_1.id, user_3.id].sort, channel_1.listener.map {|u| u.id}.sort
    
    protonet.destroy_listen(user_1.id, channel_1.id)
    
    assert_equal [user_3.id], channel_1.listener.map {|u| u.id}.sort
  end
end