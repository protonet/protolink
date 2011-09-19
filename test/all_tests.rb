$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require "rubygems"
require "protolink"
require "test/unit"

require 'ruby-debug'
Debugger.start
# change this if you need to connect to another server
PTN_SERVER = "http://localhost:3000"
PTN_USER   = "test_suite"
PTN_PASS   = "testtest"

class TestAll < Test::Unit::TestCase
  
  def teardown
    protonet = Protolink::Protonet.open(PTN_SERVER, PTN_USER, PTN_PASS)
    user_1 = protonet.find_user_by_login("test")
    user_3 = protonet.find_user_by_login("test_2")
    user_4 = protonet.find_user_by_login("test_3")

    channel = protonet.find_rendezvous(user_3.id, user_1.id)
    channel && channel.delete!

    user_1.delete!
    user_3.delete!
    user_4.delete!
    ["test_foobar", "test_foobar_2", "global"].each do |channel|
      protonet.find_channel_by_name(channel).delete! rescue nil
    end
    
  end
  
  def test_all
    protonet = Protolink::Protonet.open(PTN_SERVER, PTN_USER, PTN_PASS)
    assert protonet, "Couldn't create connection instance"
    
    user_1 = protonet.create_user(:login => 'test', :email => 'test@test.com', :external_profile_url => 'http://www.google.de')
    assert user_1.is_a?(Protolink::User), "Couldn't create user"
    assert_equal 'test', user_1.login
    assert_equal 'test@test.com', user_1.email
    assert_equal 'http://www.google.de', user_1.external_profile_url
    assert user_1.auth_token.match(/\w+/)

    assert_raise(Protolink::Protonet::ApiException) {
      protonet.create_user(:login => 'test', :email => 'test@test.com', :external_profile_url => 'http://www.google.de')
    }

    user_2 = protonet.find_or_create_user_by_login('test', :email => 'test@test.com')
    assert_equal user_1.id, user_2.id
    
    user_3 = protonet.find_or_create_user_by_login('test_2', :email => 'test_2@test.com')
    assert user_3.is_a?(Protolink::User), "Couldn't create user"
    assert_equal 'test_2', user_3.login
    assert_equal 'test_2@test.com', user_3.email
    
    user_4 = protonet.find_or_create_user_by_login('test_3', {:name => 'foobar', :email => "email@du-bist-mir-sympathisch.de", :external_profile_url => "http://du-bist-mir-sympathisch.de/profile_redirect", :avatar_url => "http://www.google.com/intl/en_com/images/srpr/logo2w.png"})
    
    channel_1 = protonet.create_channel(:name => "test_foobar", :skip_autosubscribe => true)
    assert channel_1.is_a?(Protolink::Channel), "Couldn't create channel"
    assert_equal 'test_foobar', channel_1.name
    
    channel_2 = protonet.find_or_create_channel_by_name("test_foobar")
    assert_equal channel_1.id, channel_2.id
    
    channel_3 = protonet.find_or_create_channel_by_name("test_foobar_2")
    assert channel_3.is_a?(Protolink::Channel), "Couldn't create channel"
    assert_equal 'test_foobar_2', channel_3.name
    assert channel_3.speak("dude!")["meep_id"] > 0
    
    protonet.create_listen(user_1.id, channel_1.id)
    protonet.create_listen(user_3.id, channel_1.id)
    
    assert_equal [user_1.id, user_3.id].sort, channel_1.listener.map {|u| u.id}.sort
    
    protonet.destroy_listen(user_1.id, channel_1.id)
    
    assert_equal [user_3.id], channel_1.listener.map {|u| u.id}.sort
    
    rendezvous = protonet.create_rendezvous(user_3.id, user_1.id)
    assert_equal [user_1.id, user_3.id], rendezvous.listener.map {|u| u.id.to_i}.sort
    
    channel_1 = protonet.create_channel(:name => "global", :skip_autosubscribe => true, :global => true)
    assert_equal true, channel_1.global
    
    assert_equal channel_1.id, protonet.global_channels.first.id
    assert_equal 1, protonet.global_channels.size
  end
end